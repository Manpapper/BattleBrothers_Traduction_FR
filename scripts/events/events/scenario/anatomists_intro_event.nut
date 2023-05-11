this.anatomists_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.anatomists_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_181.png[/img]{Vous avez d\'abord cru qu\'il s\'agissait de chasseurs de primes, mais ils se sont empressés de vous corriger en se présentant comme des \"rechercheurs\", et non des \"chercheurs\". Comme vous étiez encore confus, ils ont expliqué qu\'ils étaient des \"anatomistes\", ce qui n\'a pas aidé leurs efforts. Frustrés, ils vous ont traité de \"trou familier\", ce à quoi vous avez rétorqué fièrement que vous saviez ce que signifiait \"familier\", mais ils ont ri et dit que vous aviez mal entendu car ils parlaient de vous au sens d\'oiseau. Alors qu\'ils vous riaient au nez, vous avez dégainé votre épée et c\'est à ce moment-là qu\'ils ont levé les mains en l\'air, chacun tenant une bourse remplie de couronnes.\n\nAprès quelques discussions, vous avez compris qu\'il s\'agissait de grosses têtes qui s\'intéressaient de près aux cadavres. Comme vous êtes très doué pour créer des cadavres, ils ont jugé bon de vous engager pour le faire à leur place. Vous allez parcourir le pays en recrutant une formidable bande de mercenaires et en aidant ces hommes singuliers à accomplir leurs tâches scientifiques. Tout ce que vous demandez, c\'est qu\'ils ne fassent pas de choses bizarres avec votre corps si vous veniez à mourir. Les anatomistes affichent des sourires chaleureux et promettent qu\'ils ne feront jamais une telle chose à un homme avec qui ils font affaire. Chacun d\'entre eux a l\'air d\'avoir appris à sourire d\'un mort, mais vous devez les croire sur parole.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "En y réfléchissant bien, promettez-moi de laisser mon corps tranquille tant que je suis en vie.",
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
		this.m.Title = "Les Anatomistes";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

