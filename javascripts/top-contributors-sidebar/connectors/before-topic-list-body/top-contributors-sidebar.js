import { withPluginApi } from "discourse/lib/plugin-api";

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

export default {
  setupComponent(attrs, component) {
    component.set("hideSidebar", true);
    document.querySelector(".topic-list").classList.add("with-sidebar");

    if (this.site.mobileView) {
      return;
    }

    withPluginApi("0.11", (api) => {
      api.onPageChange(() => {
        component.set("isDiscoveryList", !!this.discoveryList);
        fetchDirectoryItems(settings, component);
      });
    });
  },
};
