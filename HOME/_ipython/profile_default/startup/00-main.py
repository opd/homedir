def _get_clipboard_content():
    import subprocess

    return subprocess.getoutput('pbpaste')


def import_model(model_cls, s=None):
    import json

    s = s or _get_clipboard_content()

    data = json.loads(s)
    return model_cls.objects.create(**data)


def _get_headers(curl_command):
    import argparse
    import shlex

    parts = shlex.split(curl_command)

    parser = argparse.ArgumentParser()
    parser.add_argument('curl')
    parser.add_argument('url')
    parser.add_argument('-H', '--header', action='append', default=[])
    parser.add_argument('--data-raw', dest='data_raw', default=None)
    parser.add_argument('-b', '--cookie', default=None)  # Add -b support

    args, unknown = parser.parse_known_args(parts)

    # Parse headers into a dictionary
    headers = {}
    cookies = {}
    for header in args.header:
        if ':' in header:
            key, value = header.split(':', 1)
            headers[key.strip()] = value.strip()

    for cookie in args.cookie.split(';'):
        if '=' in cookie:
            ckey, cval = cookie.strip().split('=', 1)
            cookies[ckey] = cval

    # TODO get domain from url

    result = {
        'url': args.url,
        'headers': headers,
        'data_raw': args.data_raw,
        'cookies': cookies,
        'unknown_args': unknown
    }

    return result


class DataImporter(object):
    def __init__(self, curl_command=None):
        curl_command = curl_command or _get_clipboard_content()
        self.request_kwargs = _get_headers(curl_command)


    def run_sql(self, sql):
        import requests

        payload = {
            "database": 2,
            "type": "native",
            "native": {
                "query": sql,
                "template-tags": {}
            },
            "parameters": []
        }
        response = requests.post(
            self.request_kwargs['url'],
            json=payload,
            headers=self.request_kwargs['headers'],
            cookies=self.request_kwargs['cookies'],
        )
        payload = response.json()

        data = payload['data']
        rows = data["rows"]
        if not rows:
            return []
        columns = [
            x["display_name"] for x in data['results_metadata']['columns']
        ]
        return [
            dict(zip(columns, row)) for row in rows
        ]

    def _format_pk(self, pk):
        from uuid import UUID

        if isinstance(pk, UUID):
            return "'%s'" % pk
        return str(pk)

    def _get_data_for_items(self, model_cls, ids):
        # TODO fix escaping
        table_name = model_cls._meta.db_table
        pk_name = model_cls._meta.pk.column
        ids_list = ", ".join((self._format_pk(id_) for id_ in ids))
        sql = f"""
        select * from {table_name}
        where {pk_name} in ({ids_list});
        """
        print(sql)
        return self.run_sql(sql)



    def update_items(self, items):
        items = list(items)
        model_cls = type(items[0])
        items_map = {
            item.pk: item for item in items
        }
        fetched_data = self._get_data_for_items(model_cls, items_map.keys())
        items_map = {
            str(k): v for k, v in items_map.items()
        }
        pk_name = model_cls._meta.pk.column
        for item in fetched_data:
            pk = item[pk_name]
            obj = items_map[pk]
            for key, value in item.items():
                if key == pk_name:
                    continue
                setattr(obj, key, value)
        update_fields = [f for f in fetched_data[0].keys() if f != pk_name]
        model_cls.objects.bulk_update(items, fields=update_fields)

    def create_items(self, items_qs):
        sql, params = items_qs.query.sql_with_params()
        sql = sql % params
        print(sql)
        data = self.run_sql(sql)
        model_cls = items_qs.model
        items = [
            model_cls(**item) for item in data
        ]
        model_cls.objects.bulk_create(items)
