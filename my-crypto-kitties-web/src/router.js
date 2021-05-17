import YourCatsView from "./views/YourCatsView";
import MarketplaceView from "./views/MarketplaceView";
import KittyFactoryView from "./views/KittyFactoryView";
import BreedView from "./views/BreedView";
import CatView from "./views/CatView";

export const routes = [
    {
        path: '/your-cats',
        name: 'YourCats',
        component: YourCatsView,
    },
    {
        path: '/',
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
    {
        path: '/cat/:id',
        name: 'Cat',
        component: CatView,
    },
];
