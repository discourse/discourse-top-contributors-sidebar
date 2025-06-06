import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import { and } from "truth-helpers";
import avatar from "discourse/helpers/avatar";
import icon from "discourse/helpers/d-icon";
import htmlSafe from "discourse/helpers/html-safe";
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

  <template>
    <div class="top-contributors-container-contributor">
      <div class="top-contributors-container-contributor-name">
        <span data-user-card={{this.user.username}} class="user">
          {{avatar
            this.user
            avatarTemplatePath="avatar_template"
            usernamePath="username"
            namePath="name"
            imageSize="small"
          }}

          {{#if (and settings.use_full_name this.user.name)}}
            {{this.user.name}}
          {{else}}
            {{htmlSafe this.user.username}}
          {{/if}}
        </span>
      </div>

      <div class="top-contributors-container-contributor-likes">
        {{icon "heart"}}
        {{this.likes}}
      </div>
    </div>
  </template>
}
