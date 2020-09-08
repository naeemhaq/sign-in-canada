const { I, SIC } = inject();


Given(/^I open the (.*?) page$/, (page) => {
  I.amOnPage(SIC.locators[page]);
});

Given(/^I open the url "(.*?)"$/, async (page) => {
  I.amOnPage(page);
});

When('I click on the checkbox {string}', (cb) => {
  const what = SIC.locators[cb]
  I.click(what);
});

When('I click on the link {string}', (title) => {
  const field = SIC.locators[title] || title;
  I.click(field);
});

Then(/^the url matches "(.*?)"$/, (url) => {
  I.amOnPage(url);
});

When('I choose the CSP', () => {
  // FIXME should be in page object
  const { CSP } = SIC.locators;
  if (CSP === '_local') {
    return I.amOnPage("http://localhost:8080/Sign%20In.html");
  }
  return I.click(CSP)
});

When('I click on the button {string}', (what) => {
  const field = SIC.locators[what]
  I.click(field);
});

Then('the element {string} is displayed', (what) => {
  I.see(what);
});

Then(/^the url contains "(.*?)"$/, (what) => {
  I.seeInCurrentUrl(what);
});

Then(/^I should see "(.*?)"/, (what) => {
  I.see(what);
});

Then(/^I pause for (.*?)s/, (seconds) => {
  I.wait(seconds)
});

When(/^I have a valid random GCKey username <(.*?)>/, (what) => {
  I.generateRandomUsername(what);
});

When(/^I have a valid random GCKey password <(.*?)>/, (name) => {
  I.generateRandomPassword(name);
});

When(/^I set the inputfield "(.*?)" to <(.*?)>/, async (field, name) => {
  const val = '' + await I.getRandom(name);
  I.fillField(SIC.locators[field], val);
});

When('I select the option with the text {string} for the element {string}', (element, text) => {
  I.selectOption(SIC.locators[text], element);
});

When('I set the inputfield {string} to {string}', (field, what) => {
  I.fillField(SIC.locators[field], what);
});

Then('the element {string} contains the text <testuser>', () => {
  pause();
});

Then('the browser error log should be clear', async () => {
  // WIP
  let logs = await I.grabBrowserLogs();
  return logs.length < 1;
  // logs.forEach(l => console.log(l));
});

Then(/I should have the cookie "(.*?)"/, (name) => {
  I.seeCookie(name);
});