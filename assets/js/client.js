import axios from 'axios'

axios.defaults.baseURL = '/api'
axios.defaults.headers.common['Accept'] = 'application/json'
axios.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest'

const csrf = document.head.querySelector('meta[name="csrf-token"]')
if (csrf) {
  axios.defaults.headers.common['X-CSRF-TOKEN'] = csrf.content
} else {
  console.error('CSRF token not found.')
}

export default {
  getTasks() {
    return new Promise((resolve, reject) => {
      axios.get('/tasks')
        .then(resolve)
        .catch(reject)
    })
  },

  updateTask({id}, attrs) {
    return new Promise((resolve, reject) => {
      axios.put(`/tasks/${id}`, {task: attrs})
        .then(resolve)
        .catch(reject)
    })
  }
}
