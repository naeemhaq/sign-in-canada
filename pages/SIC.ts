// const { I } = inject();

module.exports = {
  locators: {
    'RPSimulator': 'https://rp1.tbstest.catslab.ca/RPSimulator/',
    'Level 2': '//*[@id="cn-left-col-inner"]/section/div/nav/form/section[1]/ul/li[2]/input',
    'Force Authn': '//*[@id="cn-left-col-inner"]/section/div/nav/form/section[2]/ul/li[1]/input',
    'Login': '//*[@id="cn-left-col-inner"]/section/div/nav/form/section[3]/ul/li/a',
    CSP: process.env.CSP_HOST || 'DEV 3 - CATSLAB',
    'Sign up with GCKey': '//*[@id="loginForm:loginButton3"]',
    'Sign Up': { xpath: '/html/body/div[1]/main/div[2]/div/div/div/div/div/div[3]/div/p[3]/a' },
    'I accept': '//*[@id="Accept"]',
    'Create Your Username': '//*[@id="userID"]',
    'Continue': '//*[@id="button"]',
    'Create Your Password': '//*[@id="password"]',
    'Confirm Your Password': '//*[@id="confirmPassword"]',
    'Select a Recovery Question': '#recoveryQuestion',
    'My Recovery Answer': '//*[@id="recoveryAnswer"]',
    'My Memorable Person': '//*[@id="memorablePerson"]',
    'My Memorable Person Hint': '//*[@id="memorablePersonHint"]',
    'My Memorable Date': '//*[@id="memorableDate"]',
    'My Memorable Date Hint': '//*[@id="memorableDateHint"]',
    'Username confirmation': "/html/body/div/main/div[1]/div/div/div[1]/p[3]",
    'GC Key Signup Result': "/html/body/div/main/div[1]/div/div/div[1]/p[3]",
    'Sign Up Complete Continue': '//*[@id="continue"]'
  }
}
