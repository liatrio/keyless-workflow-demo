export default {
  testMatch: ["**/tests/**/*.js"],
  testEnvironment: "node",
  transform: {
    "\\.js$": [
      "babel-jest",
      {
        presets: [
          [
            "@babel/preset-env",
            {
              targets: {
                node: "current",
              },
            },
          ],
        ],
      },
    ],
  },
};
