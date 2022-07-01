import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  setupComponent(attrs, component) {
    component.set("hideSidebar", true);
    document.querySelector(".topic-list").classList.add("with-sidebar");

    if (!this.site.mobileView) {
      withPluginApi("0.11", (api) => {
        api.onPageChange(() => {
          if (settings.enable_top_contributors) {
            if (this.discoveryList) {
              if (this.isDestroyed || this.isDestroying) {
                return;
              }
              component.set("isDiscoveryList", true);

              fetch(`/directory_items.json?period=yearly&order=likes_received`)
                .then((response) => response.json())
                .then((data) => {
                  component.set("hideSidebar", false);
                  this.set("topContributors", data.directory_items.slice(0, 5));
                });
            } else {
              component.set("isDiscoveryList", false);
            }
          }
        });
      });
    }
  },
};
