"""
conftest.py defines fixtures that can be shared across multiple test files.
It is automatically discovered by pytest and does not need to be imported in test files.
refer to https://docs.pytest.org/en/stable/reference/fixtures.html#conftest-py-sharing-fixtures-across-multiple-files
"""
import pytest


@pytest.fixture
def shared_fixture() -> str:
    """
    dummy fixture for testing
    Returns:
        str: just a string
    """
    return "shared_fixture"
