from subprocess import check_output
from unittest import TestCase


class ApplyStateTest(TestCase):

    def test_000_apply(self):
        state_apply_response = check_output(["salt-call", "--local", "state.apply"])
        print('')
        print('-' * 50)
        print('state_apply_response:')
        print(state_apply_response)
        print('-' * 50)
        print('')

        state_apply_response = state_apply_response.split('\n')
        summary = state_apply_response[-8:]
        failed = 0
        for line in summary:
            if line.startswith('Failed:'):
                failed = int(line.split(':').pop().strip())

        self.assertEqual(failed, 0)
