from unittest import mock

from search import get_project_dir_and_vcs


def test_get_project_dir_and_vcs_inside_modules(monkeypatch):
    getcwd_mock = mock.Mock()
    monkeypatch.setattr('os.getcwd', getcwd_mock)
    getcwd_mock.return_value = (
        "/home/user/Projects/mysuperproject/node_modules/bootstrap"
    )
    assert get_project_dir_and_vcs() == (
        '/home/user/Projects/mysuperproject/node_modules/bootstrap',
        'js',
        '/home/user/Projects/mysuperproject/node_modules/bootstrap',
    )

    # 2
    getcwd_mock.return_value = (
        "/home/user/Projects/mysuperproject/"
        "node_modules/bootstrap/scss/mixins/"
    )
    assert get_project_dir_and_vcs() == (
        '/home/user/Projects/mysuperproject/node_modules/bootstrap',
        'js',
        '/home/user/Projects/mysuperproject/node_modules/bootstrap',
    )
    # 3
    getcwd_mock.return_value = (
        '/home/user/Projects/mysupeproject/.direnv/'
        'python-3.8.1/lib/python3.8/site-packages/django/http'
    )
    assert get_project_dir_and_vcs() == (
        (
            "/home/user/Projects/mysupeproject/.direnv/"
            "python-3.8.1/lib/python3.8/site-packages/django"
        ),
        "py",
        (
            "/home/user/Projects/mysupeproject/.direnv/"
            "python-3.8.1/lib/python3.8/site-packages/django"
        ),
    )
