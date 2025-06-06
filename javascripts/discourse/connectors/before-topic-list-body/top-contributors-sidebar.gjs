import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import { withPluginApi } from "discourse/lib/plugin-api";
import { i18n } from "discourse-i18n";
import TopContributor from "../../components/top-contributor";

const fetchDirectoryItems = (settings, component) => {
  if (!shouldFetchDirectoryItems(settings, component)) {
    return;
  }

  const requestURL = `/directory_items.json?period=yearly&order=${settings.order_by}&exclude_groups=${settings.excluded_group_names}&limit=5`;
  fetch(requestURL)
    .then((response) => response.json())
    .then((data) => {
      component.set("hideSidebar", false);
      component.set("topContributors", data.directory_items);
      component.set(
        "viewAllPath",
        `/u?order=${settings.order_by}&period=yearly`
      );
    });
};

const shouldFetchDirectoryItems = (settings, component) => {
  return (
    settings.enable_top_contributors &&
    component.discoveryList &&
    !component.isDestroyed &&
    !component.isDestroying
  );
};

@tagName("")
export default class TopContributorsSidebar extends Component {
  init() {
    super.init(...arguments);

    this.set("hideSidebar", true);
    document.querySelector(".topic-list").classList.add("with-sidebar");

    if (this.site.mobileView) {
      return;
    }

    withPluginApi("0.11", (api) => {
      api.onPageChange(() => {
        if (this.isDestroying || this.isDestroyed) {
          return;
        }

        this.set("isDiscoveryList", !!this.discoveryList);
        fetchDirectoryItems(settings, this);
      });
    });
  }

  <template>
    {{#unless this.site.mobileView}}
      {{#if this.isDiscoveryList}}
        {{#unless this.hideSidebar}}
          <div class="discourse-top-contributors">
            <h1 class="top-contributors-heading">
              {{i18n (themePrefix "top_contributors.title")}}
            </h1>

            <div class="top-contributors-container">
              {{#each this.topContributors as |user|}}
                <TopContributor @data={{user}} />
              {{/each}}

              <div class="top-contributors-container-link">
                <a href={{this.viewAllPath}}>
                  {{i18n (themePrefix "top_contributors.view_all")}}
                </a>
              </div>
            </div>
          </div>
        {{/unless}}
      {{/if}}
    {{/unless}}
  </template>
}
