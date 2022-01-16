import Component from "@ember/component";
import User from "discourse/models/user";

export default Component.extend({
  tagName: "",
  
  init() {
    this._super(...arguments);
    this.set("likes", this.data.likes_received);
    User.findByUsername(this.data.user.username).then((user) => {
      this.set("user", user);
    })
  }

})
