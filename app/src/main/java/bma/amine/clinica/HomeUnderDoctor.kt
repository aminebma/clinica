package bma.amine.clinica

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.fragment_home_under_doctor.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class HomeUnderDoctor : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_home_under_doctor, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        loadData()
        requestsList.layoutManager = LinearLayoutManager(requireActivity())

    }

    fun loadData(){
        val call = RetrofitService.endpoint.getRequests(
            requireActivity().
            getSharedPreferences("clinicaData", Context.MODE_PRIVATE)
                .getString("id","")!!
        )
        call.enqueue(object: Callback<List<Request>> {
            override fun onFailure(call: Call<List<Request>>, t: Throwable) {
                Snackbar.make(requireView(), "Une erreur s'est produite.", Snackbar.LENGTH_INDEFINITE)
                    .setAction("D'accord"){}
                    .show()
            }

            override fun onResponse(call: Call<List<Request>>, response: Response<List<Request>>) {
                if(response.isSuccessful){
                    val list = response.body()
                    requestsList.adapter = RequestAdapter(requireActivity(), list!!)
                }else{
                    Snackbar.make(requireView(), "Une erreur s'est produite.", Snackbar.LENGTH_INDEFINITE)
                        .setAction("D'accord"){}
                        .show()
                }
            }
        })
    }
}
