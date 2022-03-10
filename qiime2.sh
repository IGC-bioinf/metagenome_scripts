qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path /storage/analysis/Microbiom/samples_meta.csv --output-path /storage/analysis/Microbiom/qza/afa_project.qza --input-format PairedEndFastqManifestPhred33 
qiime demux summarize --i-data /storage/analysis/Microbiom/qza/mb_project.qza --o-visualization /storage/analysis/Microbiom/qzv/import_mb_no_NTC.qzv
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs /storage/analysis/Microbiom/qza/mb_project.qza \
  --p-trim-left-f 20 \
  --p-trim-left-r 20 \
  --p-trunc-len-f 0 \
  --p-trunc-len-r 0 \
  --p-min-fold-parent-over-abundance 8 \
  --p-max-ee-f 4 \
  --p-max-ee-r 4 \
  --o-table /storage/analysis/Microbiom/qza/mb_project_dada_maxee_4.qza \
  --p-n-threads 16 \
  --verbose \
  --o-representative-sequences /storage/analysis/Microbiom/qza/rep-seqs_mb_maxee_4.qza \
  --o-denoising-stats /storage/analysis/Microbiom/qza/denoising-stats_mb_maxee_4.qza



qiime metadata tabulate \
  --m-input-file /storage/analysis/Microbiom/qza/rep-seqs_mb_maxee_4.qza \
  --o-visualization /storage/analysis/Microbiom/qzv/stats-dada2_maxee_4_mb.qzv

nohup qiime feature-classifier classify-sklearn\
 --i-classifier /storage/analysis/Microbiom/16S_seq/gg-13-8-99-515-806-nb-weighted-classifier.qza\
 --p-n-jobs 1\
 --verbose\
 --p-reads-per-batch 10000\
 --i-reads /storage/analysis/Microbiom/qza/rep-seqs_mb_maxee_4.qza\
 --o-classification  /storage/analysis/Microbiom/qza/taxonomy_mb.qza &
 qiime metadata tabulate\
 --m-input-file/storage/analysis/Microbiom/qza/taxonomy_mb.qza
 --o-visualization /storage/analysis/Microbiom/qzv/taxonomy_mb.qzv 

qiime taxa barplot\
 --i-table /storage/analysis/Microbiom/qza/mb_project_dada_maxee_4.qza \
 --i-taxonomy /storage/analysis/Microbiom/qza/taxonomy_mb.qza \
 --m-metadata-file /storage/analysis/Microbiom/metadata_samples1_irina.csv\
 --o-visualization /storage/analysis/Microbiom/qzv/taxa-bar-plots.qzv &


qiime feature-table summarize\
 --i-table /storage/analysis/Microbiom/qza/mb_project_dada_maxee_4.qza\
 --o-visualization  /storage/analysis/Microbiom/qzv/table.qzv\
 --m-sample-metadata-file /storage/analysis/Microbiom/metadata_samples1_irina.csv

qiime feature-table tabulate-seqs\
 --i-data /storage/analysis/Microbiom/qza/rep-seqs_mb_maxee_4.qza\
 --o-visualization /storage/analysis/Microbiom/qzv/rep-seqs_mb_maxee_4.qzv

qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences /storage/analysis/Microbiom/qza/rep-seqs_mb_maxee_4.qza \
  --output-dir ./qza/tree

=================================

qiime diversity alpha-rarefaction\
 --i-table /storage/analysis/Microbiom/qza/mb_project_dada_maxee_4.qza\
 --i-phylogeny /storage/analysis/Microbiom/qza/tree/rooted_tree.qza \
 --p-max-depth 30420\
 --m-metadata-file /storage/analysis/Microbiom/metadata_samples1_irina.csv\
 --o-visualization /storage/analysis/Microbiom/qzv/alpha-rarefaction_afa.qzv





qiime diversity core-metrics-phylogenetic\
 --i-phylogeny /storage/analysis/Microbiom/qza/tree/rooted_tree.qza \
 --i-table /storage/analysis/Microbiom/qza/mb_project_dada_maxee_4.qza\
 --p-sampling-depth 30420\
 --m-metadata-file /storage/analysis/Microbiom/metadata_samples1_irina.csv\
 --output-dir qza/core_metrics_results




qiime diversity alpha-group-significance\
 --i-alpha-diversity /storage/analysis/Microbiom/qza/qza/core_metrics_results/faith_pd_vector.qza\
 --m-metadata-file /storage/analysis/Microbiom/metadata_samples1_irina.csv\
 --o-visualization qzv/faith-pd-group-significance_afa.qzv

qiime diversity alpha-group-significance\
 --i-alpha-diversity /storage/analysis/Microbiom/qza/qza/core_metrics_results/evenness_vector.qza\
 --m-metadata-file /storage/analysis/Microbiom/metadata_samples1_irina.csv\
 --o-visualization qzv/evenness-group-significance_afa.qzv

qiime diversity alpha-group-significance\
 --i-alpha-diversity /storage/analysis/Microbiom/qza/qza/core_metrics_results/shannon_vector.qza\
 --m-metadata-file /storage/analysis/Microbiom/metadata_samples1_irina.csv\
 --o-visualization qzv/shannon_group-significance_afa.qzv

++++++++++++++++++++++

qiime diversity beta-group-significance\
 --i-distance-matrix /storage/analysis/Microbiom/qza/qza/core_metrics_results/unweighted_unifrac_distance_matrix.qza\
 --m-metadata-file /storage/analysis/Microbiom/metadata_samples1_irina.csv \
 --o-visualization qzv/unweighted-unifrac-species-significance_afa.qzv\
 --p-pairwise

#qiime diversity beta-group-significance\
# --i-distance-matrix core_metrics_results/unweighted_unifrac_distance_matrix.qza\
# --m-metadata-file /home/ishtar/16S_project//storage/analysis/Microbiom/metadata_samples1_irina.csv\
# --m-metadata-column host_plant\
# --o-visualization core_metrics_results/unweighted-unifrac-host_plant-group-significance_afa.qzv\
# --p-pairwise




qiime taxa collapse \
  --i-table /storage/analysis/Microbiom/qza/mb_project_dada_maxee_4.qza \
  --i-taxonomy /home/ishtar/16S_project/qza/taxonomy_afa.qza \
  --p-level 7 \
  --output-dir ztaxa_for_OTUtable_7/


qiime tools export \
  --input-path ztaxa_for_OTUtable_7/collapsed_table.qza \
  --output-path zOTUtable_with_taxa_7

biom convert -i /home/ishtar/16S_project/zOTUtable_with_taxa_7/feature-table.biom \
 -o /home/ishtar/16S_project/zOTUtable_with_taxa_7/OTUtable_afa_with_taxa_7.tsv --to-tsv





