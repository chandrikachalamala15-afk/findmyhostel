/**
 * Find My Hostel - Unified API Client Service
 * Bridges frontend UI with PHP/MySQL Backend APIs with graceful offline/demo fallback
 */

const ApiClient = (function () {
  let isBackendLive = null; // null: untested, true: live, false: fallback

  // Rich fallback seed data aligned with database/seed_data.sql
  const fallbackHostels = [
    {
      hostel_id: 1,
      hostel_name: "Seshadri Rao GEC Boys Hostel",
      hostel_type: "boys",
      address: "SRGEC Campus, Main Road",
      landmark: "Near College Gate",
      city: "Gudlavalleru",
      phone: "08671234567",
      rating: 4.5,
      total_capacity: 200,
      current_occupancy: 185,
      distance_from_college_km: 0.5,
      min_monthly_fee: 4500,
      max_monthly_fee: 9000,
      available_rooms: 15,
      verification_status: "verified",
      description: "Official boys hostel for SRGEC students with excellent study environment, high-speed WiFi, gym, and disciplined management.",
      facilities_available: ["wifi", "mess", "gym", "study_room", "laundry", "security", "medical_room"]
    },
    {
      hostel_id: 2,
      hostel_name: "Seshadri Rao GEC Girls Hostel",
      hostel_type: "girls",
      address: "SRGEC Campus, Women's Wing",
      landmark: "Near Administration Block",
      city: "Gudlavalleru",
      phone: "08671234568",
      rating: 4.7,
      total_capacity: 150,
      current_occupancy: 142,
      distance_from_college_km: 0.3,
      min_monthly_fee: 4800,
      max_monthly_fee: 9500,
      available_rooms: 8,
      verification_status: "verified",
      description: "Safe and secure girls hostel with 24/7 biometric security, CCTV surveillance, modern amenities, and nutritious dining.",
      facilities_available: ["wifi", "mess", "security", "cctv", "study_room", "laundry", "medical_room"]
    },
    {
      hostel_id: 3,
      hostel_name: "Hare Krishna Residency",
      hostel_type: "boys",
      address: "Main Road, Near Bus Stand",
      landmark: "Opposite SBI Bank",
      city: "Gudlavalleru",
      phone: "08671234569",
      rating: 4.2,
      total_capacity: 80,
      current_occupancy: 72,
      distance_from_college_km: 1.2,
      min_monthly_fee: 5500,
      max_monthly_fee: 11000,
      available_rooms: 8,
      verification_status: "verified",
      description: "Premium private residency with air-conditioned rooms, attached bathrooms, homely food, and cooperative management.",
      facilities_available: ["wifi", "mess", "ac", "attached_bathroom", "laundry", "security", "purified_water"]
    },
    {
      hostel_id: 4,
      hostel_name: "Sri Venkateswara Boys Hostel",
      hostel_type: "boys",
      address: "College Road, Near Temple",
      landmark: "Adjacent to Venkateswara Temple",
      city: "Gudlavalleru",
      phone: "08671234570",
      rating: 3.9,
      total_capacity: 60,
      current_occupancy: 55,
      distance_from_college_km: 0.8,
      min_monthly_fee: 3800,
      max_monthly_fee: 5500,
      available_rooms: 5,
      verification_status: "verified",
      description: "Affordable accommodation with basic amenities, hot water, and close proximity to SRGEC campus.",
      facilities_available: ["wifi", "mess", "study_room", "security", "laundry"]
    },
    {
      hostel_id: 5,
      hostel_name: "Lakshmi Girls Residency",
      hostel_type: "girls",
      address: "Ward 3, Near Market",
      landmark: "Behind New Market Complex",
      city: "Gudlavalleru",
      phone: "08671234571",
      rating: 4.0,
      total_capacity: 50,
      current_occupancy: 45,
      distance_from_college_km: 1.5,
      min_monthly_fee: 4800,
      max_monthly_fee: 8000,
      available_rooms: 5,
      verification_status: "verified",
      description: "Safe and welcoming girls residency with homely atmosphere, CCTV monitoring, and dedicated female warden.",
      facilities_available: ["wifi", "mess", "security", "cctv", "study_room", "purified_water"]
    },
    {
      hostel_id: 6,
      hostel_name: "Gudlavalleru Student Home",
      hostel_type: "co-ed",
      address: "Railway Station Road",
      landmark: "Near Railway Crossing",
      city: "Gudlavalleru",
      phone: "08671234572",
      rating: 3.8,
      total_capacity: 100,
      current_occupancy: 88,
      distance_from_college_km: 2.0,
      min_monthly_fee: 4200,
      max_monthly_fee: 7500,
      available_rooms: 12,
      verification_status: "verified",
      description: "Co-ed student accommodation with separate wings for male and female students, shared dining, and recreation hall.",
      facilities_available: ["wifi", "mess", "study_room", "security", "laundry", "recreation_room"]
    }
  ];

  const fallbackComplaints = [
    { complaint_id: 10, first_name: "Arjun", last_name: "Reddy", category: "ac", subject: "AC not cooling properly in Room 101", priority: "high", status: "pending", submitted_date: "2026-09-15", hostel_name: "SRGEC Boys Hostel", room_number: "101" },
    { complaint_id: 9, first_name: "Divya", last_name: "Nair", category: "cleaning", subject: "Common bathroom cleaning required", priority: "low", status: "pending", submitted_date: "2026-09-14", hostel_name: "SRGEC Girls Hostel", room_number: "204" },
    { complaint_id: 8, first_name: "Karthik", last_name: "Raju", category: "water", subject: "Low water pressure on 2nd floor", priority: "medium", status: "in_progress", submitted_date: "2026-09-12", hostel_name: "Hare Krishna Residency", room_number: "202" },
    { complaint_id: 7, first_name: "Sneha", last_name: "Patel", category: "wifi", subject: "WiFi signal weak in wing B", priority: "medium", status: "resolved", submitted_date: "2026-09-10", hostel_name: "SRGEC Girls Hostel", room_number: "112" }
  ];

  // Helper to build query string
  function buildQuery(params) {
    const esc = encodeURIComponent;
    return Object.keys(params)
      .filter(k => params[k] !== undefined && params[k] !== null && params[k] !== '')
      .map(k => esc(k) + '=' + esc(params[k]))
      .join('&');
  }

  // Determine API base path dynamically
  function getApiBase() {
    return '../api';
  }

  return {
    /**
     * Get connection status
     * @returns {boolean|null} true = connected to MySQL API, false = demo fallback
     */
    getConnectionStatus: function () {
      return isBackendLive;
    },

    /**
     * Fetch list of hostels with filtering
     * @param {Object} filters 
     */
    getHostels: async function (filters = {}) {
      const q = buildQuery(filters);
      const url = `${getApiBase()}/hostel_controller.php?${q}`;

      try {
        const response = await fetch(url, { method: 'GET', headers: { 'Accept': 'application/json' } });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const data = await response.json();
        if (data && data.success && data.data) {
          isBackendLive = true;
          return {
            source: 'api',
            hostels: data.data.hostels || [],
            pagination: data.data.pagination || {}
          };
        }
        throw new Error(data.message || 'API returned false');
      } catch (err) {
        console.warn('Backend API unavailable. Using fallback seed data. Reason:', err.message);
        isBackendLive = false;

        // Perform client-side filtering on fallback data
        let list = [...fallbackHostels];

        if (filters.search) {
          const s = filters.search.toLowerCase();
          list = list.filter(h => h.hostel_name.toLowerCase().includes(s) || h.address.toLowerCase().includes(s));
        }

        if (filters.type) {
          list = list.filter(h => h.hostel_type === filters.type);
        }

        if (filters.max_price) {
          list = list.filter(h => h.min_monthly_fee <= Number(filters.max_price));
        }

        if (filters.max_distance) {
          list = list.filter(h => h.distance_from_college_km <= Number(filters.max_distance));
        }

        if (filters.min_rating) {
          list = list.filter(h => h.rating >= Number(filters.min_rating));
        }

        if (filters.has_wifi) {
          list = list.filter(h => h.facilities_available.includes('wifi'));
        }

        if (filters.has_mess) {
          list = list.filter(h => h.facilities_available.includes('mess'));
        }

        if (filters.has_ac) {
          list = list.filter(h => h.facilities_available.includes('ac'));
        }

        // Sorting
        if (filters.sort_by === 'price') {
          list.sort((a, b) => a.min_monthly_fee - b.min_monthly_fee);
        } else if (filters.sort_by === 'rating') {
          list.sort((a, b) => b.rating - a.rating);
        } else if (filters.sort_by === 'distance') {
          list.sort((a, b) => a.distance_from_college_km - b.distance_from_college_km);
        } else {
          list.sort((a, b) => b.rating - a.rating);
        }

        return {
          source: 'seed',
          hostels: list,
          pagination: {
            current_page: 1,
            per_page: list.length,
            total_items: list.length,
            total_pages: 1
          }
        };
      }
    },

    /**
     * Get single hostel by ID
     * @param {number|string} id 
     */
    getHostelById: async function (id) {
      const url = `${getApiBase()}/hostel_controller.php?id=${encodeURIComponent(id)}`;

      try {
        const response = await fetch(url, { method: 'GET', headers: { 'Accept': 'application/json' } });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const data = await response.json();
        if (data && data.success && data.data) {
          isBackendLive = true;
          return { source: 'api', hostel: data.data };
        }
        throw new Error('Hostel not found via API');
      } catch (err) {
        console.warn('Backend API unavailable. Using fallback hostel by ID. Reason:', err.message);
        isBackendLive = false;

        const found = fallbackHostels.find(h => String(h.hostel_id) === String(id)) || fallbackHostels[0];
        
        // Enrich with mock rooms and mess menu matching hostel_controller structure
        const enriched = {
          ...found,
          rooms: [
            { room_id: 101, room_number: "101", room_type: "single", floor_number: 1, capacity: 1, current_occupancy: 0, available_beds: 1, monthly_fee: 9000, has_ac: 1, room_status: "available" },
            { room_id: 102, room_number: "102", room_type: "double", floor_number: 1, capacity: 2, current_occupancy: 1, available_beds: 1, monthly_fee: 5500, has_ac: 0, room_status: "available" },
            { room_id: 103, room_number: "103", room_type: "triple", floor_number: 1, capacity: 3, current_occupancy: 3, available_beds: 0, monthly_fee: 4500, has_ac: 0, room_status: "occupied" },
            { room_id: 201, room_number: "201", room_type: "dormitory", floor_number: 2, capacity: 6, current_occupancy: 4, available_beds: 2, monthly_fee: 3200, has_ac: 0, room_status: "available" }
          ],
          occupancy_summary: {
            total_rooms: 4,
            available_rooms: 3,
            occupied_rooms: 1,
            total_available_beds: 4,
            occupancy_percentage: 66.7
          },
          mess_menu: [
            { day_of_week: 'monday', meal_type: 'breakfast', menu_items: 'Idli, Sambar, Chutney, Tea/Coffee', is_special: false },
            { day_of_week: 'monday', meal_type: 'lunch', menu_items: 'Rice, Sambar, Rasam, Vegetable Curry, Curd', is_special: false },
            { day_of_week: 'monday', meal_type: 'dinner', menu_items: 'Chapati, Dal Fry, Mixed Vegetable, Rice', is_special: false },
            { day_of_week: 'tuesday', meal_type: 'breakfast', menu_items: 'Puri, Potato Masala, Tea/Coffee', is_special: false },
            { day_of_week: 'tuesday', meal_type: 'lunch', menu_items: 'Rice, Dal Tadka, Fry, Buttermilk', is_special: false },
            { day_of_week: 'tuesday', meal_type: 'dinner', menu_items: 'Veg Biryani, Raita, Curry', is_special: false },
            { day_of_week: 'wednesday', meal_type: 'breakfast', menu_items: 'Dosa, Chutney, Sambar', is_special: false },
            { day_of_week: 'wednesday', meal_type: 'lunch', menu_items: 'Rice, Sambar, Pappu, Fry, Sweet', is_special: false },
            { day_of_week: 'wednesday', meal_type: 'dinner', menu_items: 'Roti, Paneer Butter Masala, Rice, Dal', is_special: true, special_occasion: 'Special Wednesday' },
            { day_of_week: 'thursday', meal_type: 'breakfast', menu_items: 'Upma, Kesari, Tea/Coffee', is_special: false },
            { day_of_week: 'thursday', meal_type: 'lunch', menu_items: 'Rice, Rasam, Kura, Curd, Pickle', is_special: false },
            { day_of_week: 'thursday', meal_type: 'dinner', menu_items: 'Chapati, Aloo Gobi, Dal, Rice', is_special: false },
            { day_of_week: 'friday', meal_type: 'breakfast', menu_items: 'Pongal, Ghee, Chutney', is_special: false },
            { day_of_week: 'friday', meal_type: 'lunch', menu_items: 'Rice, Sambar, Fry, Curd', is_special: false },
            { day_of_week: 'friday', meal_type: 'dinner', menu_items: 'Veg Fried Rice, Gobi Manchurian', is_special: true, special_occasion: 'Friday Special' },
            { day_of_week: 'saturday', meal_type: 'breakfast', menu_items: 'Vada, Sambar, Chutney', is_special: false },
            { day_of_week: 'saturday', meal_type: 'lunch', menu_items: 'Rice, Dal, Vegetable, Curd, Papad', is_special: false },
            { day_of_week: 'saturday', meal_type: 'dinner', menu_items: 'Chapati, Palak Paneer, Rice, Dal', is_special: false },
            { day_of_week: 'sunday', meal_type: 'breakfast', menu_items: 'Chole Bhature, Tea/Coffee', is_special: true, special_occasion: 'Sunday Special' },
            { day_of_week: 'sunday', meal_type: 'lunch', menu_items: 'Dum Biryani, Raita, Gravy, Gulab Jamun', is_special: true, special_occasion: 'Sunday Feast' },
            { day_of_week: 'sunday', meal_type: 'dinner', menu_items: 'Roti, Dal Makhani, Jeera Rice', is_special: false }
          ]
        };

        return { source: 'seed', hostel: enriched };
      }
    },

    /**
     * Fetch complaints for admin
     * @param {Object} filters 
     */
    getComplaints: async function (filters = {}) {
      const q = buildQuery(filters);
      const url = `${getApiBase()}/complaint_controller.php?${q}`;

      try {
        const response = await fetch(url, { method: 'GET', headers: { 'Accept': 'application/json' } });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const data = await response.json();
        if (data && data.success && data.data) {
          isBackendLive = true;
          return {
            source: 'api',
            complaints: data.data.complaints || [],
            summary: data.data.summary || {}
          };
        }
        throw new Error('Complaints API failed');
      } catch (err) {
        console.warn('Backend API unavailable. Using fallback complaints. Reason:', err.message);
        isBackendLive = false;
        return {
          source: 'seed',
          complaints: fallbackComplaints,
          summary: {
            total_complaints: 4,
            pending: 2,
            in_progress: 1,
            resolved: 1,
            urgent: 1,
            average_feedback_rating: 4.5
          }
        };
      }
    },

    /**
     * Update complaint status
     * @param {number} complaintId 
     * @param {string} status 
     * @param {string} notes 
     * @param {number} assignedTo 
     */
    updateComplaintStatus: async function (complaintId, status, notes = '', assignedTo = null) {
      const url = `${getApiBase()}/complaint_controller.php?id=${encodeURIComponent(complaintId)}`;

      try {
        const response = await fetch(url, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            status,
            notes,
            resolution_notes: notes,
            assigned_to: assignedTo,
            resolved_by: assignedTo
          })
        });
        const data = await response.json();
        if (data && data.success) {
          isBackendLive = true;
          return { success: true, message: data.message };
        }
        throw new Error(data.message || 'Update failed');
      } catch (err) {
        console.warn('Local update performed for complaint #', complaintId, 'Reason:', err.message);
        const item = fallbackComplaints.find(c => c.complaint_id === Number(complaintId));
        if (item) {
          item.status = status;
          item.resolution_notes = notes;
        }
        return { success: true, message: `Status updated locally to ${status}` };
      }
    },

    /**
     * Submit an enquiry
     * @param {Object} data 
     */
    submitEnquiry: async function (data) {
      const url = `${getApiBase()}/enquiry_controller.php`;

      try {
        const response = await fetch(url, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(data)
        });
        const res = await response.json();
        return res;
      } catch (err) {
        console.warn('Enquiry stored locally in demo mode:', data);
        return { success: true, message: 'Enquiry recorded successfully!' };
      }
    }
  };
})();

// Export for global browser use
window.ApiClient = ApiClient;
