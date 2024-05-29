const request = require('supertest');
const connection = require('../src/config/db');
const server  = require('../src/app');
const crypto = require('crypto');

describe('Authentication Endpoints', () => {
    var sessionKey;
    var nickname = 'member';
    var password = crypto.createHash('sha256').update('member').digest('hex');

    it('POST /api/login - responds with status 200 and valid token for valid credentials', async () => {
        const response = await request(server)
        .post('/api/login')
        .send({ nickname: nickname, password: password });

        expect(response.status).toBe(201);
        expect(response.body).toHaveProperty('session_key');
        sessionKey = response.body.session_key;
    });
    it('GET /api/member - responds with status 200 for a valid session key and a member', async () => {
        const response = await request(server)
            .get('/api/member')
            .set('auth', sessionKey);
  
        expect(response.status).toBe(200);
        //todo
        // expect(response.body).toEqual({
        //     nickname: 'member',
        //     name: 'member',
        //     avatar: 'Images/Avatars/member.png'
        // });    
    });
    it('GET /api/members - responds with status 200 for valid session key and list of members', async () => {
        const response = await request(server)
            .get('/api/members')
            .set('auth', sessionKey );
    
        expect(response.status).toBe(200);
        expect(response.body).not.toBeNull();
      });

    it('GET /api/getRole - responds with status 201 for valid session key and returning a role', async () => {
    const response = await request(server)
        .get('/api/getRole')
        .set('auth', sessionKey );
    
        expect(response.status).toBe(201);
        expect(response.body).toHaveProperty('role');
    });

    it('DELETE /api/logout - responds with status 200 for valid session key to delete', async () => {
        const response = await request(server)
        .delete('/api/logout')
        .set('auth', sessionKey);
        expect(response.status).toBe(200);
    });
});


//proper way to close the connection and server
afterAll((done) => {
    connection.end();  // Close the database connection
    server.close(done);  // Close the server after all tests
});