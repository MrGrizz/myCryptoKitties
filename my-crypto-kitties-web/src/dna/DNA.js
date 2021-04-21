
export class DNA {

    constructor(dna) {
        this.dna = dna;
    }

    getBodyColor() {
        return '#' + this.dna.substring(0, 6);
    }

}
