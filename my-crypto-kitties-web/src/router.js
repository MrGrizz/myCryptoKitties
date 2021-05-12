import YourCatsView from "./views/YourCatsView";
import MarketplaceView from "./views/MarketplaceView";
import KittyFactoryView from "./views/KittyFactoryView";
import BreedView from "./views/BreedView";

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
        path: '/breed',
        name: 'Breed',
        component: BreedView,
    },
    {
        path: '/kitty-factory',
        name: 'KittyFactory',
        component: KittyFactoryView,
    },
];
