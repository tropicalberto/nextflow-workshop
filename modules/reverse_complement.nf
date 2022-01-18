// process reverse_complement {
//     label 'low'

//     input:
//     val(reads)

//     output:
//     val , emit reverse_comp

//     // script:
//     // reads.
//     //     map{'A' -> 'T',
//     //         'G' -> 'C',
//     //         'C' -> 'G',
//     //         'T' -> 'A'
//     //         }
// }

params.forwardprimer = "GAC"

def complements = [ 
            A:'T', T:'A', U:'A', G:'C',
            C:'G', Y:'R', R:'Y', S:'S', 
            W:'W', K:'M', M:'K', B:'V',
            D:'H', H:'D', V:'B', N:'N'
            ]

forward_primer = Channel
                    .from(params.forwardprimer )
                    .collect()
                    .view()
                    // .collect{x -> complements[x]}
                    // .mix.view()
// forward_primer.view()

   myMap = ['A': 'T', 'G': 'C', 'C': 'G', 'T':'A']
    

def fw_rc_primer = params.forwardprimer.collect{ base -> return complements[base] ?: 'X' }.reverse().join()



forward_primer = Channel
                    .from(fw_rc_primer)
                    .collect()

forward_primer.view()


    // forward_primer.replaceAll(it, myMap[it]).view()



    // forward_primer.
    //     map{ myMap[it] }
    //     .view()  

    // // Once each letter is in a diff array
    // forward_primer.flatMap{myMap[it]}
    //     .view()
