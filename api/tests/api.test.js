const request = require('supertest');
const app = require('../src/app'); // assuming your Express app is in app.js

describe('Authentication Endpoints', () => {
    var sessionKey;
    it('POST /api/login - responds with status 200 and valid token for valid credentials', async () => {
        const response = await request(app)
        .post('/api/login')
        .send({ nickname: 'member', password: 'member' });

        expect(response.status).toBe(201);
        expect(response.body).toHaveProperty('session_key');
        sessionKey = response.body.session_key;
    });

    it('DELETE /api/logout - responds with status 200 for valid session key to delete', async () => {
        const response = await request(app)
        .delete('/api/logout')
        .set('auth', sessionKey);
    
        expect(response.status).toBe(200);
    });
});

describe('Get Members with the right premssions Endpoints', () => {
    const sessionKey = '1234567890'

    it('GET /api/member - responds with status 200 for a valid session key', async () => {
        const response = await request(app)
            .get('/api/member')
            .set('auth', sessionKey);
  
        expect(response.status).toBe(200);
    });
  
    it('GET /api/members - responds with status 200 for valid session key', async () => {
        const response = await request(app)
            .get('/api/members')
            .set('auth', sessionKey );
    
        expect(response.status).toBe(200);
      });
  });