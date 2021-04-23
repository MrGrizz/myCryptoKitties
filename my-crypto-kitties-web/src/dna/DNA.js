
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
        let cattribute = parseInt(this.dna.substring(30, 31));

        if (cattribute > 4) {
            cattribute = -cattribute + 4;
        }

        return cattribute * 2;
    }

    getCattribute2() {
        let cattribute = parseInt(this.dna.substring(31, 32));

        return cattribute % 3;
    }

}
