"""
Test the top fixture with a nested fixture
"""

import pytest


@pytest.fixture(scope="class")
def subpackage_fixture(shared_fixture: str) -> str:
    """
    a subpackage fixture that uses the shared fixture

    Args:
        shared_fixture (str): A string returned by the shared fixture.

    Returns:
        str: A string that combines the shared fixture and the subpackage fixture.
    """
    return shared_fixture + " Plus subpackage_fixture"
