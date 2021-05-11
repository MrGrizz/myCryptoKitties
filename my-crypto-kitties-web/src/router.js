import YourCatsView from "./views/YourCatsView";
import MarketplaceView from "./views/MarketplaceView";
import KittyFactoryView from "./views/KittyFactoryView";

export const routes = [
    {
        path: '/',
        name: 'YourCats',
        component: YourCatsView,
    },
    {
        path: '/marketplace',
        name: 'Marketplace',
        component: MarketplaceView,
    },
    {
        path: '/kitty-factory',
        name: 'KittyFactory',
        component: KittyFactoryView,
    },
];
