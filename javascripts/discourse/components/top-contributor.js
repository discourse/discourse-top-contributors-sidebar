import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import User from "discourse/models/user";

@tagName("")
export default class TopContributor extends Component {
  init() {
    super.init(...arguments);
    this.set("likes", this.data[settings.order_by]);
    User.findByUsername(this.data.user.username).then((user) => {
      this.set("user", user);
    });
  }
}
