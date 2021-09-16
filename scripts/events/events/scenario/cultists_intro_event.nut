this.cultists_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.cultists_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_71.png[/img]%SPEECH_ON%I put the woman and child in the barn which you have surely already found in ashes. They were knocked unconscious for he does not seek their pain. Please do not dwell upon their demise, they are with him now and in their passing I have been freed of all obligations to do what must be done. By now I will be gone. I will have taken up a new role, a new face, and beneath both I will become something I am not. I will pretend. I will act. But in the end, it is with one purpose. And you know what that purpose is. I must not name it, but you shall find it in the moments when you realize no one truly believes they are going to die. The purity of one\'s own annihilation must be clouded by distraction and merriment. Not all can see him, not all should, but see him they will.\n\nBe well, strangers that you have become, for Davkul awaits us all.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul awaits.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "The Cultists";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

