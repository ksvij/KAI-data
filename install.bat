@echo off
setlocal

REM Define the repository URL
echo connecting to KAI server
set REPO_URL=https://github.com/ksvij/KAI-data.git

REM Directory where the repository will be cloned
set REPO_DIR=%USERPROFILE%\kai-data

REM Uninstall previous DeepSeek if installed
echo Uninstalling previous DeepSeek...
pip uninstall -y deepseek

REM Remove DeepSeek-related files
echo Removing DeepSeek-related files...
rmdir /s /q %REPO_DIR%

REM Clone the repository
echo Cloning the repository...
git clone %REPO_URL% %REPO_DIR%

REM Navigate to the repository directory
cd %REPO_DIR%

REM Create a virtual environment
echo Creating a virtual environment...
python -m venv venv

REM Activate the virtual environment
echo Activating the virtual environment...
call venv\Scripts\activate

REM Upgrade pip inside the virtual environment
echo Upgrading pip...
pip install --upgrade pip

REM Install Flask and flask_cors
echo Installing Flask and flask_cors...
pip install Flask[async] flask_cors

REM Reinstall DeepSeek
echo Reinstalling DeepSeek...
pip install deepseek  REM Replace with the actual DeepSeek installation command

REM Run the AI server
echo Running the AI server...
call venv\Scripts\activate && python code-dont-pull-use-install-file/ai2.py

echo Environment setup complete! To activate the virtual environment, run 'venv\Scripts\activate'.

endlocal
pause
