package bma.amine.clinica

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.github.mikephil.charting.data.PieData
import com.github.mikephil.charting.data.PieDataSet
import com.github.mikephil.charting.data.PieEntry
import com.github.mikephil.charting.utils.ColorTemplate
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.fragment_dashboard.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.text.SimpleDateFormat
import java.util.*

class Dashboard : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_dashboard, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val call = RetrofitService
            .endpoint
            .getAllRequests(
                requireActivity()
                    .getSharedPreferences("clinicaData", Context.MODE_PRIVATE)
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
                    if(response.body()?.size != 0){
                        val requests = response.body()
                        val todayRequests = requests!!.filter { it.date.subSequence(0,10) == SimpleDateFormat("yyyy-MM-dd").format(Date()) }
                        val yesterdayRequests = requests.subtract(todayRequests)
                        val answeredRequests = requests!!.filter {
                            it.date.subSequence(0,10) == SimpleDateFormat("yyyy-MM-dd").format(Date())
                                    && it.status=="answered"
                        }

                        val requestsNumber = ArrayList<PieEntry>()
                        requestsNumber.add(PieEntry(todayRequests.size.toFloat(), "En cours"))
                        requestsNumber.add(PieEntry(answeredRequests.size.toFloat(), "Traitées"))

                        val pieDataSet = PieDataSet(requestsNumber, "           Nombre de demandes de diagnostique du jour")
                        pieDataSet.setColors(ColorTemplate.MATERIAL_COLORS.toList())

                        val pieData = PieData(pieDataSet)
                        pieData.setValueTextSize(14f)

                        requestsChart.data = pieData

                        requestsChart.description.isEnabled = false
                        requestsChart.setEntryLabelTextSize(10f)
                        requestsChart.animateXY(500,500)

                        if(todayRequests.size!=0)
                            evolution.text = "Taux d'évolution du nombre de demandes de diagnostique:\n${(todayRequests.size-yesterdayRequests.size)*100/todayRequests.size}"
                        else
                            evolution.text = "Taux d'évolution du nombre de demandes de diagnostique:\n-100%"
                    }
                    else{
                        evolution.text = "Vous n'avez reçu aucune demande de diagnostique"
                    }

                }
            }

        })
    }
}
