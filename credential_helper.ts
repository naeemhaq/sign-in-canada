class CredentialHelper extends codeceptjs.Helper {
  references = {};

  generateRandomUsername(ref) {
    this.references[ref] = ['sic', Math.floor(Date.now() / 1000).toString(36), Math.floor(Math.random() * 1e8).toString(36)].join('_');
    return this.references[ref];
  }

  generateRandomPassword(ref) {
    this.references[ref] = ['testpass', Math.floor(Math.random() * 1e8).toString(36).toUpperCase()].join('_');
    return this.references[ref];
  }

  getRandom(name) {
    const val = this.references[name];
    return val;
  }


  // before/after hooks
  /**
   * @protected
   */
  _before() {
    // remove if not used
  }

  /**
   * @protected
   */
  _after() {
    // remove if not used
  }

  // add custom methods here
  // If you need to access other helpers
  // use: this.helpers['helperName']

}

module.exports = CredentialHelper;