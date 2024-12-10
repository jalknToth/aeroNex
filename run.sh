GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

set -e

command -v python3 >/dev/null 2>&1 || { echo >&2 "Python3 is required but not installed.  Aborting."; exit 1; }
command -v virtualenv >/dev/null 2>&1 || { python3 -m pip install --user virtualenv; }
command -v mysql >/dev/null 2>&1 || { echo >&2 "MySQL is required but not installed.  Aborting."; exit 1; }


createStructure() {
    echo -e "${YELLOW}🏗️ Creating Project Directory Structure${NC}"

    # Create subdirectories
    mkdir -p {src/{models,controllers},static/{css,js,img},templates} || { echo "Error creating directories"; exit 1; }
    
    touch .env app.py config.py .gitignore requirements.txt

    # Create placeholder files for src
    touch src/models/{user.py,drone.py,booking.py}
    touch src/controllers/{auth.py,dash.py,map.py,booking.py}

    # Create placeholder files for static
    touch static/css/style.css static/js/script.js static/img/favicon.png}

    # Create placeholder files for templates
    touch templates/{base.html,login.html,register.html,dash.html,map.html,booking.html,payment.html}
}

gitignore() {
    echo -e "${YELLOW}♠︎ Generating .gitignore file${NC}"
    cat > .gitignore << EOL
.vscode
__pycache__
*.pyc
.venv
.env
logs/
EOL
}

creatEnv() {
    echo -e "${YELLOW}🔐 Generating .env file${NC}"
    cat > .env << EOL
# Database Configuration
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=aeroNex

# Flask Configuration
FLASK_APP=app.py
FLASK_ENV=development
SECRET_KEY=$(openssl rand -hex 32)

# Upload Configuration
UPLOAD_FOLDER=./uploads
MAX_CONTENT_LENGTH=16777216  # 16MB

# Logging
LOG_LEVEL=INFO
LOG_FILE=./logs/app.log
EOL
}

setProject() {
    createStructure
    gitignore
    creatEnv

    echo -e "${GREEN}✨ Project created successfully!${NC}"
}

main() {
    echo -e "${YELLOW}🔧 AeroNex Application Initialization${NC}"

    setProject

    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
    pip install --use-pep517 python-dotenv
    pip install --upgrade pip setuptools wheel
    pip install mysql.connector flask waitress bcrypt
   
    source .env
    chmod 600 .env

    echo -e "${GREEN}🎉 Project is ready! Run 'source .venv/bin/activate' to start.${NC}"
}
 main
