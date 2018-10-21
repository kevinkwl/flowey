from flask_restplus import Namespace, Resource

api = Namespace('auth', description='authentication APIs')

@api.route('/')
class Hello(Resource):
    @api.doc('test api hello')
    def get(self):
        '''hello'''
        return 'HELLO from flowey.'
