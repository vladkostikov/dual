import React from 'react';
import PropTypes from 'prop-types';

import Card from '@material-ui/core/Card';
import CardHeader from '@material-ui/core/CardHeader';
import CardContent from '@material-ui/core/CardContent';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import EditIcon from '@material-ui/icons/Edit';

import TaskPresenter from 'presenters/TaskPresenter';

import UseStyles from './useStyles';

function Task({ task, onClick }) {
  const styles = UseStyles();

  const handleClick = () => onClick(task);
  const action = (
    <IconButton onClick={handleClick}>
      <EditIcon />
    </IconButton>
  );

  return (
    <Card className={styles.root}>
      <CardHeader action={action} title={TaskPresenter.name(task)} />
      <CardContent>
        <Typography variant="body2" color="textSecondary" component="p">
          {TaskPresenter.description(task)}
        </Typography>
      </CardContent>
    </Card>
  );
}

Task.propTypes = {
  task: PropTypes.shape({
    name: TaskPresenter.ownPropTypes.name,
    description: TaskPresenter.ownPropTypes.description,
  }).isRequired,
  onClick: PropTypes.func.isRequired,
};

export default Task;
