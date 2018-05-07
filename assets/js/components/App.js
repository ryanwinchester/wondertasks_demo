import React from 'react'
import ReactDOM from 'react-dom'
import {Row, Col, Media} from 'react-bootstrap'
import _uniq from 'lodash.uniq'
import client from '../client'

const ALL_GROUPS = -1
const NO_GROUP = -2

export default class App extends React.Component {
  constructor() {
    super()
    this.state = {
      tasks: [],
      selectedGroup: NO_GROUP,
    }
  }

  componentDidMount() {
    this.fetchTasks()
  }

  groups() {
    return _uniq(this.state.tasks.map((task) => task.group))
  }

  selectedTasks() {
    if (this.state.selectedGroup === NO_GROUP) return []
    if (this.state.selectedGroup === ALL_GROUPS) return this.state.tasks

    return this.state.tasks.filter((task) => {
      return task.group == this.groups()[this.state.selectedGroup]
    })
  }

  groupTasks(group) {
    return this.state.tasks.filter((task) => task.group == group)
  }

  groupTotals(group) {
    const tasks = this.groupTasks(group)
    return {
      completed_count: tasks.filter((task) => task.completedAt).length,
      total_count: tasks.length
    }
  }

  taskState(task) {
    if (this.isLocked(task)) return 'Locked'
    if (!task.completedAt) return 'Incomplete'
    return 'Completed'
  }

  isLocked(task) {
    return !task.dependencyIds.reduce((acc, parent_id) => {
      const parent = this.state.tasks.find((t) => t.id == parent_id)
      return acc && parent && parent.completedAt
    }, true)
  }

  fetchTasks(group_id) {
    client.getTasks()
      .then(({data}) => {this.setState({tasks: data})})
      .catch(console.log)
  }

  updateTask(task, attrs) {
    client.updateTask(task, attrs)
      .then(() => this.fetchTasks())
      .catch(console.log)
  }

  selectGroup(index, e) {
    e.preventDefault()
    const max = this.groups().length - 1
    const selectedGroup = index > max ? 0 : index
    this.setState({selectedGroup})
  }

  toggleComplete(task, e) {
    e.preventDefault()
    if (this.isLocked(task)) return false
    const completed_at = !task.completedAt ? (new Date()).toISOString() : null
    this.updateTask(task, {completed_at})
  }

  render() {
    const groupList = this.groups().map((group, i) => {
      const groupTotals = this.groupTotals(group)
      return (
        <Media.ListItem key={group} onClick={this.selectGroup.bind(this, i)} className="Group">
          <Media.Left>
            <img width={7} height={9} src="/images/Group.svg" alt="completed" />
          </Media.Left>
          <Media.Body>
            <Media.Heading>{group}</Media.Heading>
            <p className="group-subheading">{groupTotals.completed_count} out of {groupTotals.total_count} tasks complete</p>
          </Media.Body>
        </Media.ListItem>
      )
    })

    const taskList = this.selectedTasks().map((task) => {
      const taskState = this.taskState(task)
      return (
        <Media.ListItem key={task.id} onClick={this.toggleComplete.bind(this, task)} className={`${taskState} Task`}>
          <Media.Left>
            <img width={21} height={21} src={`/images/${taskState}.svg`} />
          </Media.Left>
          <Media.Body>
            <Media.Heading>{task.task}</Media.Heading>
          </Media.Body>
        </Media.ListItem>
      )
    })

    return (
      <div>
        <Row>
          <Col md={4} mdOffset={1}>
            <h2 className="task-list-header">Things To Do</h2>
            <Media.List>{groupList}</Media.List>
          </Col>
          <Col md={4}>
            <h2 className="task-list-header">
              Task Group
              <a href="#all-groups" className="pull-right" onClick={this.selectGroup.bind(this, ALL_GROUPS)}>
                <small>ALL GROUPS</small>
              </a>
            </h2>
            <Media.List>{taskList}</Media.List>
          </Col>
        </Row>
      </div>
    )
  }
}

ReactDOM.render(<App/>, document.getElementById('app'));
