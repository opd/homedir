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


# TODO
def install_playwright():
    """Install playwright and required browsers if not present."""
    print("🔍 Checking for Playwright...")
    
    try:
        import playwright
        print("✅ Playwright is already installed.")
        return True
    except ImportError:
        print("📦 Installing playwright via pip...")
        try:
            subprocess.check_call([
                sys.executable, "-m", "pip", "install", "playwright"
            ])
            print("✅ Playwright installed successfully.")
        except subprocess.CalledProcessError as e:
            print("❌ Failed to install Playwright.")
            print(e)
            return False

    print("🌐 Installing Playwright Chromium browser...")
    try:
        subprocess.check_call([
            sys.executable, "-m", "playwright", "install", "chromium"
        ])
        print("✅ Chromium browser installed.")
    except subprocess.CalledProcessError as e:
        print("❌ Failed to install Chromium.")
        print(e)
        return False

    return True


def _get_headers_for_url(url):
    install_playwright()
    pass


class DataImporter(object):
    def __init__(self, curl_command=None):
        if curl_command.startswith('http'):
            self.request_kwargs = _get_headers_for_url(curl_command)
        else:
            curl_command = curl_command or _get_clipboard_content()
            self.request_kwargs = _get_headers(curl_command)


    def _save_data_to_json(self, data, json_file):
        import json
        from pathlib import Path

        path = Path(json_file).expanduser()
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(
            json.dumps(data, indent=2, ensure_ascii=False, default=str)
        )

    def run_sql(self, sql, json_file=None):
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
        if 'error' in payload:
            print(payload['error'])

        data = payload['data']
        rows = data["rows"]
        if not rows:
            return []
        columns = [
            x["display_name"] for x in data['results_metadata']['columns']
        ]
        result = [
            dict(zip(columns, row)) for row in rows
        ]
        if json_file:
            self._save_data_to_json(result, json_file)
        return result

    def get_data(self, sql, json_file=None):
        return self.run_sql(sql, json_file=json_file)

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


    def _build_item(self, model_cls, params):
        from django.db import models
        field_map = {
            f.attname: f for f in model_cls._meta.fields
        }
        updated_params = params.copy()
        for key, value in params.items():
            field = field_map[key]
            if isinstance(field, models.JSONField):
                import pdb;pdb.set_trace()
            elif isinstance(field, models.DateField):
                if value is None:
                    continue
                value = value[:10]
            else:
                continue
            updated_params[key] = value
        return model_cls(**updated_params)



    def update_items(self, items):
        import json
        from django.db import models
        
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
        
        # Get JSON fields for introspection
        json_fields = {
            field.column: field for field in model_cls._meta.fields
            if isinstance(field, models.JSONField)
        }
        
        for item in fetched_data:
            pk = item[pk_name]
            obj = items_map[pk]
            for key, value in item.items():
                if key == pk_name:
                    continue
                
                # Check if this is a JSON field and value is a string
                if key in json_fields and isinstance(value, str):
                    try:
                        value = json.loads(value)
                    except (json.JSONDecodeError, TypeError):
                        # If parsing fails, keep original string value
                        pass
                
                setattr(obj, key, value)
        update_fields = [f for f in fetched_data[0].keys() if f != pk_name]
        model_cls.objects.bulk_update(items, fields=update_fields)

    def create_items(self, items_qs, ignore_conflicts=False):
        from django.db import connection

        sql, params = items_qs.query.sql_with_params()
        with connection.cursor() as cursor:
            # This returns the full SQL string with params safely quoted
            compiled_sql = cursor.cursor.mogrify(sql, params)
        sql = compiled_sql
        print(sql)
        data = self.run_sql(sql)
        model_cls = items_qs.model
        items = [
            self._build_item(model_cls, item) for item in data
        ]
        model_cls.objects.bulk_create(items, ignore_conflicts=ignore_conflicts)

    def upsert_items(self, items_qs):
        self.create_items(items_qs, ignore_conflicts=True)
        self.update_items(items_qs)
