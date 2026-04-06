import { createElement } from 'lwc';
import LmsComponentX from 'c/lmsComponentX';
import { unsubscribe } from 'lightning/messageService';

jest.mock(
    'lightning/messageService',
    () => {
        return {
            APPLICATION_SCOPE: 'APPLICATION_SCOPE',
            MessageContext: jest.fn(),
            subscribe: jest.fn(() => ({ id: 'mockSubscription' })),
            unsubscribe: jest.fn()
        };
    },
    { virtual: true }
);

describe('c-lms-component-x', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('uses fallback text when message payload is missing', () => {
        const element = createElement('c-lms-component-x', {
            is: LmsComponentX
        });
        document.body.appendChild(element);

        element.handleMessage(undefined);

        expect(element.receivedMessage).toBe('NO Message published');
    });

    it('stores message value when payload is present', () => {
        const element = createElement('c-lms-component-x', {
            is: LmsComponentX
        });
        document.body.appendChild(element);

        element.handleMessage({
            lmsData: {
                value: 'Hello LMS'
            }
        });

        expect(element.receivedMessage).toBe('Hello LMS');
    });

    it('unsubscribes and clears subscription', () => {
        const element = createElement('c-lms-component-x', {
            is: LmsComponentX
        });
        document.body.appendChild(element);

        element.subscription = { id: 'existingSubscription' };
        element.unsubscribeMessage();

        expect(unsubscribe).toHaveBeenCalledWith({ id: 'existingSubscription' });
        expect(element.subscription).toBeNull();
    });
});
