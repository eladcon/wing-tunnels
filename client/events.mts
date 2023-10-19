import events from 'events';

export const eventHandler = new events.EventEmitter();

export enum Events {
  DomainAssigned = "DOMAIN_ASSIGNED"
}
