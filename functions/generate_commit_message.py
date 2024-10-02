# generate_commit_message.py

import subprocess
import os
from pydantic import Field
from instructor import OpenAISchema


class Function(OpenAISchema):
    """
    Generates a concise and descriptive git commit message based on the current staged changes.
    """

    class Config:
        title = "generate_commit_message"

    @classmethod
    def execute(cls) -> str:
        """
        Retrieves the git diff of the currently staged changes and returns it.
        """
        try:
            # Get current working directory
            current_dir = os.getcwd()
            # Get the diff of staged changes
            result = subprocess.run(
                ['git', 'diff', '--staged'],
                capture_output=True,
                text=True,
                cwd=current_dir
            )
            diff_output = result.stdout

            if not diff_output.strip():
                return f"No staged changes to generate a commit message from. Current directory: {current_dir}"
            else:
                return diff_output

        except Exception as e:
            return f"Error retrieving git diff in {current_dir}: {e}"
