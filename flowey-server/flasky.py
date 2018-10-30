import os
from flowey import create_app, db
from flowey.models import User
from flask_migrate import Migrate

app = create_app(os.getenv('FLASK_CONFIG') or 'default')
migrate = Migrate(app, db)


@app.shell_context_processor
def make_shell_context():
    return dict(db=db, User=User)


@app.cli.command()
def test():
    """Run the unit tests."""
    import unittest
    tests = unittest.TestLoader().discover('tests')
    unittest.TextTestRunner(verbosity=2).run(tests)


@app.cli.command()
def sampledata():
    from sample_data import SampleData
    sd = SampleData()
    sd.add_users()
    sd.del_users()
    sd.add_transactions()
    sd.del_transactions()
