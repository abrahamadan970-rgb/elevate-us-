import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Client-Info, Apikey",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 200, headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const resendApiKey = Deno.env.get("RESEND_API_KEY") || "re_HqD94tE8_FEW2nHi513Z7CkFYKQCadBXi";

    const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    });

    // Get all members with emails
    const { data: members, error: memberErr } = await supabaseAdmin
      .from("members")
      .select("full_name, email, status")
      .not("email", "is", null)
      .neq("email", "")
      .order("full_name");

    if (memberErr) {
      return new Response(
        JSON.stringify({ error: "Failed to fetch members: " + memberErr.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const results: { email: string; full_name: string; sent: boolean; error?: string }[] = [];

    for (const member of members ?? []) {
      const email = member.email.toLowerCase();
      const fullName = member.full_name;

      const emailHtml = `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
          <div style="background: linear-gradient(135deg, #0369a1, #0ea5e9); padding: 30px; border-radius: 12px 12px 0 0; text-align: center;">
            <h1 style="color: white; margin: 0; font-size: 28px;">ElevateUS Association</h1>
            <p style="color: #e0f2fe; margin: 8px 0 0;">Your account has been created</p>
          </div>
          <div style="background: #f8fafc; padding: 30px; border-radius: 0 0 12px 12px; border: 1px solid #e2e8f0;">
            <h2 style="color: #1e293b; margin-top: 0;">Welcome, ${fullName}!</h2>
            <p style="color: #475569; font-size: 15px; line-height: 1.6;">
              Your account for the ElevateUS Association management portal has been created.
              You can now log in using the credentials below.
            </p>
            <div style="background: white; border: 1px solid #cbd5e1; border-radius: 8px; padding: 20px; margin: 20px 0;">
              <table style="width: 100%; font-size: 15px;">
                <tr><td style="color: #64748b; padding: 6px 0;">Email:</td><td style="color: #1e293b; font-weight: 600; padding: 6px 0;">${email}</td></tr>
                <tr><td style="color: #64748b; padding: 6px 0;">Password:</td><td style="color: #1e293b; font-weight: 600; padding: 6px 0;">ElevateUS</td></tr>
              </table>
            </div>
            <div style="background: #fef3c7; border: 1px solid #fde68a; border-radius: 8px; padding: 16px; margin: 16px 0;">
              <p style="color: #92400e; margin: 0; font-size: 14px; font-weight: 600;">
                Important: You will be required to change your password after your first login for security.
              </p>
            </div>
            <p style="color: #475569; font-size: 14px; line-height: 1.6;">
              After logging in, go to Settings to update your password and complete your profile.
            </p>
            <p style="color: #64748b; font-size: 13px; margin-top: 24px;">
              ElevateUS Association<br/>
              This is an automated message — please do not reply.
            </p>
          </div>
        </div>
      `;

      const emailResp = await fetch("https://api.resend.com/emails", {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${resendApiKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          from: "ElevateUS Association <onboarding@resend.dev>",
          to: [email],
          subject: "Your ElevateUS Account Credentials",
          html: emailHtml,
        }),
      });

      if (!emailResp.ok) {
        const errBody = await emailResp.json();
        results.push({ email, full_name: fullName, sent: false, error: errBody.message || `HTTP ${emailResp.status}` });
        continue;
      }

      results.push({ email, full_name: fullName, sent: true });
    }

    const sent = results.filter((r) => r.sent).length;
    const failed = results.filter((r) => !r.sent).length;

    return new Response(
      JSON.stringify({ success: true, total: results.length, sent, failed, results }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: (error as Error).message || "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
