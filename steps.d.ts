/// <reference types='codeceptjs' />
type steps_file = typeof import('./steps_file.js');
type SIC = typeof import('./pages/SIC');

declare namespace CodeceptJS {
  interface SupportObject { I: I, SIC: SIC }
  interface Methods extends Playwright, CredentialHelper, IntrospectHelper {}
  interface I extends ReturnType<steps_file> {}
  namespace Translation {
    interface Actions {}
  }
}
