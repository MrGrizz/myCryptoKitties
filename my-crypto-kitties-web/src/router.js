import YourCatsView from "./views/YourCatsView";
import MarketplaceView from "./views/MarketplaceView";

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
];
