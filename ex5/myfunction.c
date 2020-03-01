#define min(a,b) (a < b ? a : b)
#define max(a,b) (a > b ? a : b)
#define calcIndex(i,j,n) ((i)*(n)+(j))

typedef struct {
   unsigned char red;
   unsigned char green;
   unsigned char blue;
} pixel;

typedef struct {
    int red;
    int green;
    int blue;
} pixel_sum;

void myfunction(Image *image, char* srcImgpName, char* blurRsltImgName, char* sharpRsltImgName) {
	Image tmp = *image;

	// blur image
		
	int size = m*n;
	pixel* pixelsImg = malloc(size*sizeof(pixel));
	pixel* backupOrg = malloc(size*sizeof(pixel));

	pixel* src = pixelsImg;
	pixel* dst = backupOrg;

	int row, col;
	int rowN;
	int calculate1;
	int calculate2 = m - 1;
	int i;
	int j;

	for (row = 0 ; row < m ; ++row) {
		rowN = row*n;
		calculate1 = (rowN << 1) + rowN;
		
		for (col = 0 ; col < n ; ++col) {

			src[rowN + col].red = tmp.data[calculate1 + (col << 1) + col];
			dst[rowN + col].red = src[rowN + col].red;
			src[rowN + col].green = tmp.data[calculate1 + (col << 1) + col + 1];
			dst[rowN + col].green = src[rowN + col].green;
			src[rowN + col].blue = tmp.data[calculate1 + (col << 1) + col + 2];
			dst[rowN + col].blue = src[rowN + col].blue;
		}
	}
		
	pixel_sum sum;
	pixel current_pixel;
	sum.red = sum.green = sum.blue = 0;

	for (i = 1; i < calculate2; ++i) {

		int up = m*(i-1);
		int current = m*i;
		int down = m*(i+1);

		for (j = 1; j < calculate2; ++j) {

			sum.red = backupOrg[up+(j-1)].red + backupOrg[up+j].red + backupOrg[up+(j+1)].red + backupOrg[current+(j+1)].red + backupOrg[current+j].red;
			sum.red += backupOrg[current+(j-1)].red + backupOrg[down+(j-1)].red + backupOrg[down+j].red + backupOrg[down+(j+1)].red;
			sum.green = backupOrg[up+(j-1)].green + backupOrg[up+j].green + backupOrg[up+j+1].green + backupOrg[current+(j+1)].green;
			sum.green += backupOrg[current+j].green + backupOrg[current+j-1].green + backupOrg[down+j-1].green + backupOrg[down+j].green + backupOrg[down+(j+1)].green;
			sum.blue =  backupOrg[up+(j-1)].blue + backupOrg[up+j].blue + backupOrg[up+(j+1)].blue + backupOrg[current+(j+1)].blue;
			sum.blue += backupOrg[current+j].blue + backupOrg[current+(j-1)].blue + backupOrg[down+(j-1)].blue + backupOrg[down+j].blue + backupOrg[down+(j+1)].blue;
			

			// assign kernel's result to pixel at [i,j]
			pixel *current_pixel_ptr = &current_pixel;
			
			// divide by kernel's weight

			sum.red = sum.red / 9;
			sum.green = sum.green / 9;
			sum.blue = sum.blue / 9;

			// truncate each pixel's color values to match the range [0,255]
			current_pixel_ptr->red = (unsigned char) (min(max(sum.red, 0), 255));
			current_pixel_ptr->green = (unsigned char) (min(max(sum.green, 0), 255));
			current_pixel_ptr->blue = (unsigned char) (min(max(sum.blue, 0), 255));

			pixelsImg[calcIndex(i, j, m)] = current_pixel;
		}
	}

	for (row = 0 ; row < m ; ++row) {
		rowN = row*n;
		calculate1 = (rowN << 1) + rowN;
		for (col = 0 ; col < n ; ++col) {

			tmp.data[calculate1 + (col << 1) + col] = pixelsImg[rowN + col].red;
			tmp.data[calculate1 + (col << 1) + col + 1] = pixelsImg[rowN + col].green;
			tmp.data[calculate1 + (col << 1) + col + 2] = pixelsImg[rowN + col].blue;
		}
	}

	// write result image to file
	writeBMP(image, srcImgpName, blurRsltImgName);

	// sharpen the resulting image
	src = pixelsImg;
	dst = backupOrg;

	for (row = 0 ; row < m ; ++row) {
		rowN = row*n;
		calculate1 = (rowN << 1) + rowN;
		
		for (col = 0 ; col < n ; ++col) {

			src[rowN + col].red = tmp.data[calculate1 + (col << 1) + col];
			dst[rowN + col].red = src[rowN + col].red;
			src[rowN + col].green = tmp.data[calculate1 + (col << 1) + col + 1];
			dst[rowN + col].green = src[rowN + col].green;
			src[rowN + col].blue = tmp.data[calculate1 + (col << 1) + col + 2];
			dst[rowN + col].blue = src[rowN + col].blue;
		}
	}
		
	for (i = 1; i < calculate2; ++i) {
		int up = m*(i-1);
		int current = m*i;
		int down = m*(i+1);
		for (j = 1; j < calculate2; ++j) {

			sum.red = - backupOrg[up+(j-1)].red - backupOrg[up+j].red - backupOrg[up+(j+1)].red - backupOrg[current+(j+1)].red + 9*backupOrg[current+j].red;
			sum.red += - backupOrg[current+(j-1)].red - backupOrg[down+(j-1)].red - backupOrg[down+j].red - backupOrg[down+(j+1)].red;
			sum.green = - backupOrg[up+(j-1)].green - backupOrg[up+j].green - backupOrg[up+j+1].green - backupOrg[current+(j+1)].green;
			sum.green += 9*backupOrg[current+j].green - backupOrg[current+j-1].green - backupOrg[down+j-1].green - backupOrg[down+j].green - backupOrg[down+(j+1)].green;
			sum.blue =  - backupOrg[up+(j-1)].blue - backupOrg[up+j].blue - backupOrg[up+(j+1)].blue - backupOrg[current+(j+1)].blue;
			sum.blue += 9*backupOrg[current+j].blue - backupOrg[current+(j-1)].blue - backupOrg[down+(j-1)].blue - backupOrg[down+j].blue - backupOrg[down+(j+1)].blue;
			

			// assign kernel's result to pixel at [i,j]
			pixel *current_pixel_ptr = &current_pixel;
			
			// truncate each pixel's color values to match the range [0,255]
			current_pixel_ptr->red = (unsigned char) (min(max(sum.red, 0), 255));
			current_pixel_ptr->green = (unsigned char) (min(max(sum.green, 0), 255));
			current_pixel_ptr->blue = (unsigned char) (min(max(sum.blue, 0), 255));

			pixelsImg[calcIndex(i, j, m)] = current_pixel;
		}
	}

	for (row = 0 ; row < m ; ++row) {
		rowN = row*n;
		calculate1 = (rowN << 1) + rowN;
		for (col = 0 ; col < n ; ++col) {

			tmp.data[calculate1 + (col << 1) + col] = pixelsImg[rowN + col].red;
			tmp.data[calculate1 + (col << 1) + col + 1] = pixelsImg[rowN + col].green;
			tmp.data[calculate1 + (col << 1) + col + 2] = pixelsImg[rowN + col].blue;
		}
	}

	free(pixelsImg);
	free(backupOrg);

	// write result image to file
	writeBMP(image, srcImgpName, sharpRsltImgName);
}


