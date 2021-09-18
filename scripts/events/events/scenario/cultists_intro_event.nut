this.cultists_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.cultists_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_71.png[/img]%SPEECH_ON%J\'ai mis la femme et l\'enfant dans la grange que vous avez sûrement déjà trouvée en cendres. Ils ont été assommés, car il ne veut pas qu\'ils souffrent. S\'il vous plaît, ne vous attardez pas sur leur mort, ils sont avec lui maintenant et dans leur passage, j\'ai été libéré de toute obligation de faire ce qui doit être fait. A présent, je vais partir. J\'aurai pris un nouveau rôle, un nouveau visage, et sous les deux, je deviendrai quelque chose que je ne suis pas. Je ferai semblant. Je jouerai la comédie. Mais au final, c\'est dans un seul but. Et vous savez quel est ce but. Je ne dois pas le nommer, mais vous le trouverez dans les moments où vous réaliserez que personne ne croit vraiment qu\'il va mourir. La pureté de son propre anéantissement doit être obscurcie par la distraction et la joie. Tous ne peuvent pas le voir, tous ne devraient pas, mais ils le verront.\n\n Portez-vous bien, étrangers que vous êtes devenus, car Davkul nous attend tous.%SPEECH_OFF%",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Davkul attend.",
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

