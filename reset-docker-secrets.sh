#!/usr/bin/env bash
set -e

echo "🔹 Starting Docker Hub Secret Reset"

# --- Gather project info ---
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

echo "🔹 Project ID: $PROJECT_ID"
echo "🔹 Project Number: $PROJECT_NUMBER"

# --- 1. Delete old secrets (if they exist) ---
echo "🧹 Deleting any existing Docker Hub secrets..."
gcloud secrets delete docker-hub-pat --quiet || true
gcloud secrets delete docker-hub-username --quiet || true

# --- 2. Recreate clean secrets without newline characters ---
# ⚠️ Replace YOUR_DOCKERHUB_PAT below with your real Docker Hub token (starts with dckr_pat_)
echo -n "dckr_pat_REPLACE_WITH_YOUR_TOKEN" | \
  gcloud secrets create docker-hub-pat --data-file=- \
  --replication-policy="automatic"

# ⚠️ Replace username if different
echo -n "ammaralikhan00" | \
  gcloud secrets create docker-hub-username --data-file=- \
  --replication-policy="automatic"

# --- 3. Grant permissions ---
echo "🔐 Granting access to Cloud Build and Compute service accounts..."
# Cloud Build default SA
gcloud secrets add-iam-policy-binding docker-hub-pat \
  --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor" --quiet
gcloud secrets add-iam-policy-binding docker-hub-username \
  --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor" --quiet

# Compute default SA (used for local builds)
gcloud secrets add-iam-policy-binding docker-hub-pat \
  --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor" --quiet
gcloud secrets add-iam-policy-binding docker-hub-username \
  --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor" --quiet

# --- 4. Verify ---
echo "✅ Verifying policies..."
gcloud secrets get-iam-policy docker-hub-pat --format="yaml" | grep serviceAccount || true
gcloud secrets get-iam-policy docker-hub-username --format="yaml" | grep serviceAccount || true

echo "🎉 Docker Hub secrets reset complete!"
