from flask import Flask
from flask.cli import FlaskGroup

def create_app(script_info=None):
    app = Flask(__name__)

    @app.route('/')
    def index():
        return 'route "/"'

    return app

app = create_app()

cli = FlaskGroup(create_app=create_app)

if __name__ == '__main__':
    cli()
