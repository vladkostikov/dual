import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles(() => ({
  actions: {
    display: 'flex',
    justifyContent: 'flex-end',
  },

  form: {
    display: 'flex',
    flexDirection: 'column',
  },

  modal: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    outline: 0,
  },

  root: {
    width: 465,
  },
}));

export default useStyles;
