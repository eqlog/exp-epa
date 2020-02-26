use std::vec::Vec;
use std::collections::{HashMap, HashSet};
use std::iter::{FromIterator, once};
use crate::union_find::UnionFind;
use crate::element::Element;
#[cfg(test)]
use crate::element::el;

pub type Row = Vec<Element>;

// supposed to map some projection of a full row to the set of all rows with that projection
pub type ProjectionIndex = HashMap<Row, HashSet<Row>>;

pub fn project<T: Copy>(projection: &[usize], row: &[T], row_projection: &mut [T]) {
    for (i, p) in projection.iter().enumerate() {
        row_projection[i] = row[*p];
    }
}

fn is_projection_index(rows: &HashSet<Row>, projection: &[usize], index: &ProjectionIndex) -> bool {
    let mut row_projection = Vec::with_capacity(projection.len());
    row_projection.resize(projection.len(), Element::default());
    rows.iter().all(|row| {
        // all rows should be in the index at the right key
        project(&projection, row, &mut row_projection[..]);
        match index.get(&row_projection[..]) {
            None => false,
            Some(matching_rows) => matching_rows.contains(row)
        }
    }) &&
    index.iter().all(|(row_proj, matching_rows)| {
        // rows at some key in the index should have the correct projection and occure in rows
        matching_rows.iter().all(|row| {
            project(&projection, row, &mut row_projection[..]);
            *row_proj == row_projection && rows.contains(row)
        })
    })
}

#[cfg(test)]
mod test_is_projection_index {
    use super::*;

    fn example() -> (Vec<usize>, HashSet<Row>, ProjectionIndex) {
        let projection = vec![0, 2];

        let rows: HashSet<Row> = hashset!{
            vec![el(0), el(1), el(2)],
            vec![el(1), el(2), el(3)],
            vec![el(1), el(0), el(3)],
            vec![el(3), el(2), el(1)],
        };

        let index: ProjectionIndex = hashmap!{
            vec![el(0), el(2)] => hashset!{vec![el(0), el(1), el(2)]},
            vec![el(1), el(3)] => hashset!{vec![el(1), el(2), el(3)], vec![el(1), el(0), el(3)]},
            vec![el(3), el(1)] => hashset!{vec![el(3), el(2), el(1)]},
        };

        (projection, rows, index)
    }

    #[test]
    fn completeness() {
        let (projection, rows, index) = example();
        assert!(is_projection_index(&rows, &projection, &index));
    }

    #[test]
    fn soundness_index_missing_key() {
        let (projection, mut rows, index) = example();
        rows.insert(vec![el(500), el(2), el(1)]);
        assert!(!is_projection_index(&rows, &projection, &index));
    }

    #[test]
    fn soundness_index_missing_row() {
        let (projection, mut rows, index) = example();
         // `rows` contains at least one row [el(3), _, el(1)] already
        rows.insert(vec![el(3), el(500), el(1)]); 
        assert!(!is_projection_index(&rows, &projection, &index));
    }

    #[test]
    fn soundness_index_extraneous_key() {
        let (projection, rows, mut index) = example();
        index.insert(
            vec![el(500), el(1)],
            hashset!{vec![el(500), el(2), el(1)]}
        );
        assert!(!is_projection_index(&rows, &projection, &index));
    }

    #[test]
    fn soundness_index_extraneous_row() {
        let (projection, rows, mut index) = example();
        index.get_mut(&vec![el(1), el(3)]).unwrap().insert(vec![el(1), el(500), el(3)]);
        assert!(!is_projection_index(&rows, &projection, &index));
    }
}

fn extend_projection_index<I>(projection: &[usize], index: &mut ProjectionIndex, rows: I)
where
    I: IntoIterator<Item = Row>
{
    let mut row_projection = Vec::with_capacity(projection.len());
    row_projection.resize(projection.len(), Element::default());
    for row in rows {
        project(projection, &row, &mut row_projection);

        match index.get_mut(&row_projection) {
            Some(matching_rows) => {
                matching_rows.insert(row);
            },
            None => {
                index.insert(row_projection.clone(), hashset!{row});
            },
        }
    }
}

fn make_projection_index(projection: &[usize], rows: &HashSet<Row>) -> ProjectionIndex {
    let mut index: ProjectionIndex = HashMap::new();
    extend_projection_index(projection, &mut index, rows.iter().map(|row| row.clone()));
    index
}

#[cfg(test)] #[test]
fn test_make_projection_index() {
    let rows: HashSet<Row> = hashset!{
        vec![el(0), el(1), el(2)],
        vec![el(1), el(2), el(3)],
        vec![el(1), el(0), el(3)],
        vec![el(3), el(2), el(1)],
    };
    
    for projection in &[vec![], vec![0], vec![1], vec![2], vec![0, 2], vec![1, 0], vec![2, 1, 0]] {
        let index = make_projection_index(&projection, &rows);
        assert!(is_projection_index(&rows, &projection, &index));
    }
}

type ElementIndex = HashMap<Element, HashSet<Row>>;

fn is_element_index(rows: &HashSet<Row>, index: &ElementIndex) -> bool {
    index.iter().all(|(el, matching_rows)| {
        matching_rows.iter().all(|row| row.contains(el) && rows.contains(row))
    }) &&
    rows.iter().all(|row| {
        row.iter().all(|el| {
            match index.get(el) {
                None => false,
                Some(matching_rows) => matching_rows.contains(row),
            }
        })
    })
}

#[cfg(test)]
mod test_is_element_index {
    use super::*;

    pub fn example() -> (HashSet<Row>, ElementIndex) {
        let rows: HashSet<Row> = hashset!{
            vec![el(0), el(1), el(2)],
            vec![el(1), el(2), el(3)],
            vec![el(1), el(0), el(3)],
            vec![el(3), el(2), el(1)],
        };

        let index: ElementIndex = hashmap!{
            el(0) => hashset!{vec![el(0), el(1), el(2)], vec![el(1), el(0), el(3)]},
            el(1) => rows.clone(),
            el(2) => hashset!{vec![el(0), el(1), el(2)], vec![el(1), el(2), el(3)], vec![el(3), el(2), el(1)]},
            el(3) => hashset!{vec![el(1), el(0), el(3)], vec![el(1), el(2), el(3)], vec![el(3), el(2), el(1)]},
        };

        (rows, index)
    }

    #[test]
    fn completeness() {
        let (rows, index) = example();
        assert!(is_element_index(&rows, &index));
    }

    #[test]
    fn completeness_empty_els() {
        let (rows, mut index) = example();
        index.insert(el(500), hashset!{});
        assert!(is_element_index(&rows, &index));
    }

    #[test]
    fn soundness_index_missing_key() {
        let (mut rows, index) = example();
        rows.insert(vec![el(500), el(500), el(500)]);
        assert!(!is_element_index(&rows, &index));
    }

    #[test]
    fn soundness_index_missing_row() {
        let (mut rows, index) = example();
        rows.insert(vec![el(0), el(2), el(3)]);
        assert!(!is_element_index(&rows, &index));
    }

    #[test]
    fn soundness_index_extraneous_row() {
        let (rows, mut index) = example();
        index.get_mut(&el(0)).unwrap().insert(vec![el(3), el(2), el(1)]);
        assert!(!is_element_index(&rows, &index));
    }

    #[test]
    fn soundness_index_extraneous_key_and_row() {
        let (rows, mut index) = example();
        index.insert(el(500), hashset!{vec![el(500), el(600), el(700)]});
        assert!(!is_element_index(&rows, &index));
    }
}

fn extend_element_index<I>(index: &mut ElementIndex, rows: I)
where
    I: IntoIterator<Item = Row>
{
    for row in rows {
        for el in &row {
            match index.get_mut(el) {
                Some(matching_rows) => {
                    matching_rows.insert(row.clone());
                },
                None => {
                    index.insert(*el, hashset!{row.clone()});
                },
            }
        }
    }
}

#[cfg(test)]
fn make_element_index(rows: &HashSet<Row>) -> ElementIndex {
    let mut index: ElementIndex = HashMap::new();
    extend_element_index(&mut index, rows.iter().map(|row| row.clone()));
    index
}

#[cfg(test)] #[test]
fn test_make_element_index() {
    let (rows, index) = test_is_element_index::example();
    assert_eq!(make_element_index(&rows), index);
}

pub struct Relation {
    row_len: usize,
    // all rows in this relation
    rows: HashSet<Row>,
    // indices for projections specified by a list of indices into the row
    projection_indices: HashMap<Vec<usize>, ProjectionIndex>,
    // maps elements into the set of rows containing them
    element_index: HashMap<Element, HashSet<Row>>,
}

impl Relation {
    fn new(row_len: usize) -> Self {
        Relation {
            row_len,
            rows: HashSet::new(),
            projection_indices: HashMap::new(),
            element_index: HashMap::new(),
        }
    }
    
    pub fn row_len(&self) -> usize {
        self.row_len
    }
    pub fn rows(&self) -> &HashSet<Row> {
        &self.rows
    }
    pub fn projection_indices(&self) -> &HashMap<Vec<usize>, ProjectionIndex> {
        &self.projection_indices
    }
    pub fn element_index(&self) -> &ElementIndex {
        &self.element_index
    }
    pub fn add_projection_index(&mut self, projection: Vec<usize>) {
        if self.projection_indices.contains_key(&projection) {
            return;
        }

        for i in &projection {
            assert!(*i < self.row_len);
        }

        let index = make_projection_index(&projection, &self.rows);
        self.projection_indices.insert(projection, index);
    }
    pub fn remove_projection_index(&mut self, projection: &Vec<usize>) {
        self.projection_indices.remove(projection);
    }
}

impl Extend<Row> for Relation {
    fn extend<I: IntoIterator<Item = Row>>(&mut self, rows: I) {
        for row in rows {
            assert_eq!(row.len(), self.row_len);
            let was_inserted = self.rows.insert(row.clone());

            if was_inserted {
                for (projection, mut index) in self.projection_indices.iter_mut() {
                    extend_projection_index(&projection, &mut index, once(row.clone()));
                }
                extend_element_index(&mut self.element_index, once(row));
            }
        }

        debug_assert!(is_element_index(&self.rows, &self.element_index));
        for (projection, index) in &self.projection_indices {
            debug_assert!(is_projection_index(&self.rows, projection, index));
        }
    }
}


#[derive(Copy, Clone, PartialEq, Eq, Hash, Debug)]
pub struct SortId(pub usize);
#[derive(Copy, Clone, PartialEq, Eq, Hash, Debug)]
pub struct RelationId(pub usize);

// Some default values, fixed but chosen randomly
impl Default for SortId {
    fn default() -> Self {
        SortId(2201843232216218232)
    }
}

pub struct Signature {
    pub sort_number: usize,
    pub relation_arities: Vec<Vec<SortId>>,
    // relations are identified by their index in `relation_arities`
}

pub struct Model<'a> {
    signature: &'a Signature,
    element_sorts: HashMap<Element, SortId>,
    element_representatives: UnionFind,
    relations: Vec<Relation>,
}

impl<'a> Model<'a> {
    pub fn signature(&self) -> &'a Signature {
        self.signature
    }
    pub fn element_sorts(&self) -> &HashMap<Element, SortId> {
        &self.element_sorts
    }
    pub fn element_representatives(&self) -> &UnionFind {
        &self.element_representatives
    }
    pub fn relations(&self) -> &Vec<Relation> {
        &self.relations
    }

    pub fn new(signature: &'a Signature) -> Self {
        let relations = Vec::from_iter(
            signature.relation_arities.iter().
            map(|arity| Relation::new(arity.len()))
        );
        Model {
            signature,
            element_sorts: HashMap::new(),
            element_representatives: UnionFind::new(),
            relations
        }
    }

    pub fn new_element(&mut self, sort: SortId) -> Element {
        let SortId(s) = sort;
        assert!(s < self.signature.sort_number);

        let el = self.element_representatives.add_element();
        self.element_sorts.insert(el, sort);
        el
    }
    pub fn extend_relation<I: IntoIterator<Item = Row>>(&mut self, relation_id: RelationId, rows: I) {
        let RelationId(r) = relation_id;
        assert!(r < self.signature.relation_arities.len());

        let arity = &self.signature.relation_arities[r];

        // get reference to element_sorts so that the lambda passed to `inspect` doesn't need to
        // capture `self`, which is also needed to access `self.relations[r]`
        let element_sorts = &mut self.element_sorts;

        self.relations[r].extend(rows.into_iter().inspect(|row| {
            assert_eq!(arity.len(), row.len());
            for (el, sort) in row.iter().zip(arity.iter()) {
                assert_eq!(element_sorts.get(el), Some(sort));
            }
        }));
    }
}
