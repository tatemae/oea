import startApp from '../helpers/start-app';

window.OEA_SETTINGS = {
  qtiUrl: 'http://localhost:4200/fixtures/8.xml',
  userId: '1',
  resultsEndPoint: 'http://localhost:4200/api'
};

test('index transitions to question', function(){
  startApp();
  visit('/');
  andThen(function(){
    equal(find('div.header p').text(), 'Question 1');
  });
});
