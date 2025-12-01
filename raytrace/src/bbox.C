/*************************************************************************/
/*                                                                       */
/*  Copyright (c) 1994 Stanford University                               */
/*                                                                       */
/*  All rights reserved.                                                 */
/*                                                                       */
/*  Permission is given to use, copy, and modify this software for any   */
/*  non-commercial purpose as long as this copyright notice is not       */
/*  removed.  All other uses, including redistribution in whole or in    */
/*  part, are forbidden without prior written permission.                */
/*                                                                       */
/*  This software is provided with absolutely no warranty and no         */
/*  support.                                                             */
/*                                                                       */
/*************************************************************************/


/*
 * NAME
 *	bbox.c
 *
 * DESCRIPTION
 *	This file contains routines that read, inquire, and normalize bounding
 *	boxes.
 */


#include <stdio.h>
#include <math.h>
#include "rt.h"

INT	DataType;			/* Ascii or binary geometry file.    */

INT	TraversalType;			/* Linked list or HUG traversal.     */

INT	bundlex, bundley;		/* Bundle sizes for workpools.	     */
INT	blockx, blocky; 		/* Block sizes for workpools.	     */

BOOL	GeoFile;			/* TRUE if geometry file name found. */
BOOL	PicFile;			/* TRUE if picture file name found.  */
BOOL	ModelNorm;			/* TRUE if model must be normalized. */
BOOL	ModelTransform; 		/* TRUE if model transform present.  */
BOOL	AntiAlias;			/* TRUE if antialiasing enabled.     */

CHAR	GeoFileName[80];		/* Geometry file name.		     */
CHAR	PicFileName[80];		/* Picture file name.		     */

VIEW	View;				/* Viewing parameters.		     */
DISPLAY Display;			/* Display parameters.		     */
LIGHT	*lights;			/* Ptr to light list.		     */
INT	nlights;			/* Number of lights in scene.	     */

GMEM	*gm;				/* Ptr to global memory structure.   */



GRID	*world_level_grid;		/* Zero level grid pointer.	     */

INT	hu_max_prims_cell;		/* Max # of prims per cell.	     */
INT	hu_gridsize;			/* Grid size.			     */
INT	hu_numbuckets;			/* Hash table bucket size.	     */
INT	hu_max_subdiv_level;		/* Maximum level of hierarchy.	     */
INT	hu_lazy;			/* Lazy evaluation indicator.	     */

INT	prim_obj_cnt;			/* Totals for model.		     */
INT	prim_elem_cnt;
INT	subdiv_cnt;
INT	bintree_cnt;

INT	grids;
INT	total_cells;
INT	empty_voxels;
INT	nonempty_voxels;
INT	nonempty_leafs;
INT	prims_in_leafs;

UINT	empty_masks[sizeof(UINT)*8];
UINT	nonempty_masks[sizeof(UINT)*8];

/*
 * NAME
 *	InquireBoundBoxValues - return min and max bound values for each coordinate axis
 *
 * SYNOPSIS
 *	VOID	InquireBoundBoxValues(pbb, minx, miny, minz, maxx, maxy, maxz)
 *	BBOX	*pbb;				// Ptr to bounding box.
 *	REAL	*minx, *miny, *minz;		// Near planes.
 *	REAL	*maxx, *maxy, *maxz;		// Far planes.
 *
 * RETURNS
 *	Nothing.
 */

VOID	InquireBoundBoxValues(pbb, minx, miny, minz, maxx, maxy, maxz)
BBOX	*pbb;
REAL	*minx, *miny, *minz;
REAL	*maxx, *maxy, *maxz;
	{
	*minx = pbb->dnear[0];
	*miny = pbb->dnear[1];
	*minz = pbb->dnear[2];
	*maxx = pbb->dfar[0];
	*maxy = pbb->dfar[1];
	*maxz = pbb->dfar[2];
	}



/*
 * NAME
 *	NormalizeBoundBox - normalize bounding box given a normalization matrix
 *
 * SYNOPSIS
 *	VOID	NormalizeBoundBox(bv, mat)
 *	BBOX	*pbb;				// Ptr to bounding box.
 *	MATRIX	mat;				// Normalization matrix.
 *
 * RETURNS
 *	Nothing.
 */

VOID	NormalizeBoundBox(pbb, mat)
BBOX	*pbb;
MATRIX	mat;
	{
	POINT	tmp;

	/* dnear and dfar are only vectors of length 3 */

	tmp[0] = pbb->dnear[0];
	tmp[1] = pbb->dnear[1];
	tmp[2] = pbb->dnear[2];
	tmp[3] = 1.0;

	VecMatMult(tmp, mat, tmp);

	pbb->dnear[0] = tmp[0];
	pbb->dnear[1] = tmp[1];
	pbb->dnear[2] = tmp[2];

	tmp[0] = pbb->dfar[0];
	tmp[1] = pbb->dfar[1];
	tmp[2] = pbb->dfar[2];
	tmp[3] = 1.0;

	VecMatMult(tmp, mat, tmp);

	pbb->dfar[0] = tmp[0];
	pbb->dfar[1] = tmp[1];
	pbb->dfar[2] = tmp[2];
	}

