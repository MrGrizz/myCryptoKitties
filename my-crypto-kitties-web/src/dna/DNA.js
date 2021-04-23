
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

    getColor5() {
        return '#' + this.dna.substring(24, 30);
    }

    getCattribute1() {
        let cattribute1 = parseInt(this.dna.substring(30, 31));

        if (cattribute1 > 4) {
            cattribute1 = -cattribute1 + 4;
        }

        return cattribute1 * 2;
    }

}
