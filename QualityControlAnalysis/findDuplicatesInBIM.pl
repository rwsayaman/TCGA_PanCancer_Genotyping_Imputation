#! /usr/local/bin/perl
# written by Scott Huntsman
# shuntsman@medicine.ucsf.edu

# find markers with duplicate positions in bim file, and print out dups to file (DOES NOT PRINT LAST OCCUR, unless uncommented below 

#usage findDuplicatesInBIM.pl bimfile outfile

$bimFilePath = $ARGV[0];



$outFilePath = $ARGV[1];  #"liftedhg19_".$bimFilePath;

open (OUTFILE, ">$outFilePath");

$numDup = 0;

open (BIMFILE, "$bimFilePath");
print "opening $bimFilePath\n";
#$title = <BIMFILE>;
while (<BIMFILE>) {
  #chomp;
  @row = split(/\s+/);
  $chr = $row[0];
  $rs = $row[1];
  $pos = $row[3];

  $key = $chr."-".$pos;

  if (exists $all{$key}) {
    $old = $all{$key};
    @dup = split(/\s+/, $old);
    $numDup++;
    print OUTFILE "$dup[1]\n";   
    #print OUTFILE "$_";    ### uncomment to also print out last occur, otherwise only earlier dups printed
    $all{$key} = $_;
  } else {
    $all{$key} = $_;
  }
}
close (BIMFILE);

print "Done loading bim File\n";
print "$numDup dups found\n";
close (OUTFILE);

print "DONE\n";
