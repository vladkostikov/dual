import { pick, propOr } from 'ramda';

export default {
  defaultAttributes(attributes) {
    return {
      name: '',
      description: '',
      ...attributes,
    };
  },

  attributesToSubmit(task) {
    const permittedKeys = ['id', 'name', 'description'];

    return {
      ...pick(permittedKeys, task),
      assigneeId: propOr(null, 'id', task.assignee),
      authorId: propOr(null, 'id', task.author),
    };
  },
};
