
export class DNA {

    constructor(dna) {
        this.dna = dna;
    }

    getColor1() {
        return '#' + this.dna.substring(0, 6);
    }

    getColor2() {
        return '#' + this.dna.substring(6, 12);
    }

    getColor3() {
        return '#' + this.dna.substring(12, 18);
    }

    getColor4() {
        return '#' + this.dna.substring(18, 24);
    }

}
