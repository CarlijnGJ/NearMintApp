const swaggerJsdoc = require('swagger-jsdoc');

// Swagger definition
const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'NearMintGaming API Documentation',
    version: '0.5.0',
    description: 'API endpoints for NearMintGaming',
  },
};

// Options for the swagger-jsdoc plugin
const options = {
  swaggerDefinition,
  server: [
    {
      url: 'http://localhost:3000',
      description: 'Development',
    },
    // {
    //   url: 'https://nearmintgaming.com',
    //   description: 'Production server',
    // },
  ],
  // Paths to files containing OpenAPI definitions
  apis: ['./routes/*.js'],
};

// Initialize swagger-jsdoc
const swaggerSpec = swaggerJsdoc(options);

module.exports = swaggerSpec;
