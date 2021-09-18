this.raiders_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.raiders_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_94.png[/img]{Après que vous et votre groupe ayez tué la moitié d\'entre eux, les villageois se sont finalement soumis. Un drapeau blanc a été hissé, et ils ont offert une contrepartie que vous avez été heureux d\'accorder. En une seule file, ils se sont dirigés vers la place de la ville où ils avaient organisé une fête. Des bijoux et des trésors remplissaient leurs bras et ils ont jeté les marchandises là où vous vous teniez, la botte sur le crâne brisé de leur maire. Votre avant-garde de %raider1%, %raider2%, %raider3% et %raider4% surveillait attentivement la cérémonie, comme des buses observant une mort lente.\n\nLe dernier de la file était un moine. Il n\'avait pas d\'or ni d\'argent sur lui, mais s\'adressait à vous, ses mots attirant immédiatement les armes de vos compagnons d\'infortune. Vous l\'avez laissé parler, et il a longuement parlé des anciens dieux et de la façon dont les trésors des cieux remplaçaient tout ce que la terre pouvait offrir. Vous lui avez dit que sa mort était écrite par son menton remuant. Le moine pinça les lèvres%SPEECH_ON%D\'accord, alors si vous voulez de l\'or, abandonnez ces jeux stupides. Ces raids et ces pillages, tout cela ne vaut rien comparé aux trésors du sud. Les nobles ne veulent pas de toi dans leurs armées, mais ils ont toujours besoin de mercenaires et ont rarement le temps ou le luxe de choisir d\'où viennent ces combattants engagés.Vous feriez toutes les couronnes que vous voudriez. Venez au sud, pillards, et soyez sublimés en mercenaires. %SPEECH_OFF%%raider3% demande la tête du moine, mais vous arrêtez l\'exécution. Au lieu de cela, vous prenez le moine rusé au mot. Vous avez longtemps entendu parler des richesses du sud et des voyages des aventuriers qui louent des épées. Vous décidez de vous aventurer dans le sud, à condition que le moine vienne avec vous. %raider3% proteste, mais vous l\'ignorez. Si cette petite merde de moine est votre porte-bonheur pour une nouvelle vie, alors ce serait un affront aux anciens dieux de le laisser. Le pillard s\'en va, mais %raider1%, %raider2% et %raider4% n\'ont aucun scrupule à vous suivre. Le reste du groupe de guerre retourne au nord, le butin étant partagé. Ce qui reste du village est laissé derrière pour récupérer, reconstruire et fabriquer de nouveaux biens que les tribus plus fortes viendront prendre pour elles-mêmes.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous irons vers le sud.",
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
		this.m.Title = "The Northern Raiders";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		_vars.push([
			"raider1",
			brothers[0].getName()
		]);
		_vars.push([
			"raider2",
			brothers[1].getName()
		]);
		_vars.push([
			"raider3",
			this.Const.Strings.BarbarianNames[this.Math.rand(0, this.Const.Strings.BarbarianNames.len() - 1)]
		]);
		_vars.push([
			"raider4",
			brothers[2].getName()
		]);
	}

	function onClear()
	{
	}

});

